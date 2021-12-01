# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send(:include, InstanceMethods)
  end

  module ClassMethods
    attr_reader :all_to_validate

    def validate(attr_name, validation_type, validation_param = nil)
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

    def validate_presence(*params) # на случай, если будет меняться количество параметров для валидации
      # требует, чтобы значение атрибута было не nil и не пустой строкой
      raise "Attribute can't be nil or empty string!" if params.first.nil? || params.first.length == 0
    end

    def validate_format(*params)
      # требует соответствия значения атрибута заданному регулярному выражению
      raise 'Invalid format!' if params.first !~ params[1]
    end

    def validate_type(*params)
      # требует соответствия значения атрибута заданному классу
      raise 'Invalid type/class!' unless params.first.instance_of?(params[1])
    end

    def validate!
      self.class.all_to_validate.each do |validation|
        var_name = instance_variable_get(validation[0])
        validation_type = validation[1]
        validation_param = validation[2]
        if validation_param.nil? && %i[format type].include?(validation_type)
          raise 'Wrong number of arguments!'
        end # обазателен какой-то параметр

        send("validate_#{validation_type}", var_name, validation_param)
      end
    end
  end
end
