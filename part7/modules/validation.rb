# frozen_string_literal: true

# этот модуль у меня уже был, для valid?, требуемое в задании просто дописала сюда же
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    attr_reader :all_to_validate

    def validate(attr_name, validation_type, validation_param = nil)
      available_validation_types = %i[presence format type]
      unless available_validation_types.include?(validation_type)
        raise 'Invalid validation type'
      end # если передаётся неправильный тип, пусть сразу кидается исключение

      @all_to_validate ||= []
      @all_to_validate.push(["@#{attr_name}".to_sym, validation_type, validation_param])
    end
  end

  module InstanceMethods
    def valid? # этот метод используется у меня в интерфейсе, так что он должен остаться public
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!
      self.class.all_to_validate.each do |validation|
        var_name = instance_variable_get(validation[0])
        validation_type = validation[1]
        validation_param = validation[2]
        if validation_param.nil? && %i[format type].include?(validation_type)
          raise 'Wrong number of arguments!'
        end # обазателен какой-то параметр

        case validation_type
        when :presence
          # требует, чтобы значение атрибута было не nil и не пустой строкой
          raise "Attribute #{var_name} can't be nil or empty string!" if var_name.nil? || var_name.length == 0
          # puts "presense validation for #{var_name.to_s} is passed"
        when :format
          # треубет соответствия значения атрибута заданному регулярному выражению
          raise "Invalid format of #{var_name}" if var_name !~ validation_param
          # puts "format validation for #{var_name.to_s} is passed"
        when :type
          # требует соответствия значения атрибута заданному классу
          raise "Invalid type/class of #{var_name}" unless var_name.instance_of?(validation_param)
          # puts "type validation for #{var_name.to_s} is passed"
        end
      end
    end
  end
end
