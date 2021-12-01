module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        define_method(name) { instance_variable_get(var_name) }   # геттер
        define_method("#{name}=".to_sym) do |value| # сеттер с записью истории
          instance_variable_set(var_name, value)
          @histories ||= {}
          @histories[var_name] ||= []
          @histories[var_name].push(value)
        end
        define_method("#{name}_history") { @histories["@#{name}".to_sym] } # получение истории
      end
    end

    def strong_attr_accessor(name, attr_type)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) } # геттер
      define_method("#{name}=".to_sym) do |value|   # сеттер с проверкой типа
        raise 'Wrong Type Error' unless attr_type == value.class

        instance_variable_set(var_name, value)
      end
    end
  end
end
