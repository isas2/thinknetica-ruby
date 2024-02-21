# frozen_string_literal: true

require_relative 'lib/accessors'
require_relative 'lib/validation'

class A
  include Accessors
  include Validation

  attr_accessor_with_history :test
  validate :train_number, :presence
  validate :train_number, :type, String
  validate :train_number, :format, /^[а-я\d]{3}-*[а-я\d]{2}$/i
  validate :test, :presence

  def initialize
    self.test = 0
    @train_number = '60-1-ЧА'
  end
end

class B < A
  include Accessors

  attr_accessor_with_history :total
end

class C
  include Accessors

  attr_accessor_with_history :test
  strong_attr_accessor :check, String
end

def debug(obj_name, obj)
  class_name = obj.class.name
  puts "\n------ Object #{obj_name} (#{class_name}) ------"
  if obj.methods.include?(:test)
    puts "#{obj_name}.test #{obj.test}"
    puts "#{obj_name}.test_history #{obj.test_history}"
  end
  if obj.methods.include?(:total)
    puts "#{obj_name}.total #{obj.total}"
    puts "#{obj_name}.total_history #{obj.total_history}"
  end
  puts "#{obj_name}.instance_variables #{obj.instance_variables}"
end

puts "Проверка установки атрибутов и ведения истории...\n"
a = A.new
b = B.new
c = C.new
debug('a', a)
debug('b', b)
debug('c', c)

puts "\n---------------------\n"
a.test = 23
a.test = 8
b.total = 5
b.total = 'new value'
debug('a', a)
debug('b', b)

puts "\nПроверка атрибута со \"строгой типизацией\"...\n"
c.check = 'Test str'
puts c.check
begin
  # Исключение, неверный тип данных
  c.check = 12
rescue TypeError => e
  puts "Ошибка! #{e.message}"
end

puts "\nПроверка валидаторов значений атрибутов...\n"
puts "A.instance_variable_get('@validators'):"
puts A.instance_variable_get('@validators')
puts "a.valid? #{a.valid?}"
unless a.valid?
  begin
    a.validate!
  rescue RuntimeError => e
    puts "Ошибка! #{e.message}"
  end
end
