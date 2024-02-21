# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(*attr)
      raise TypeError, 'Attribute name is not symbol' unless attr[0].is_a?(Symbol)
      raise TypeError, 'Validation type is not symbol' unless attr[1].is_a?(Symbol)

      validators = instance_variable_get('@validators') || []
      attr_hash = {}
      %i[name type option].each_with_index { |n, i| attr_hash[n] = attr[i] }
      instance_variable_set('@validators', validators << attr_hash)
    end
  end

  module InstanceMethods
    def validate!
      validators = self.class.instance_variable_get('@validators')
      validators = self.class.superclass.instance_variable_get('@validators') if validators.nil?
      validators.each do |validator|
        name = validator[:name]
        attr = instance_variable_get("@#{name}")
        case validator[:type]
        when :presence
          raise "An uninitialized attribute '#{name}'" if attr.nil? || attr == ''
        when :format
          if !attr.nil? && (attr !~ validator[:option])
            # если nil, то проверка не пройдёт, но если арибут обязателен, то :presence
            raise "Invalid data format '#{name}'"
          end
        when :type
          if !attr.nil? && !attr.instance_of?(validator[:option])
            # если nil, то проверка не пройдёт, но если арибут обязателен, то :presence
            raise "Invalid value type '#{name}'"
          end
        when :in
          raise "Attribute value out of range '#{name}'" unless validator[:option].include?(attr)
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
