# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*methods)
      methods.each do |method|
        raise TypeError, 'Method name is not symbol' unless method.is_a?(Symbol)

        define_method(method) do
          instance_variable_get("@#{method}")
        end

        define_method("#{method}=") do |v|
          instance_variable_set("@#{method}", v)
          history = instance_variable_get("@#{method}_history") || []
          instance_variable_set("@#{method}_history", history << v)
        end

        define_method("#{method}_history") do
          instance_variable_get("@#{method}_history")
        end
      end
    end

    def strong_attr_accessor(method, type)
      raise TypeError, 'Method name is not symbol' unless method.is_a?(Symbol)

      define_method(method) do
        instance_variable_get("@#{method}")
      end

      define_method("#{method}=") do |v|
        raise TypeError, 'Invalid value type' unless v.instance_of? type

        instance_variable_set("@#{method}", v)
      end
    end
  end
end
