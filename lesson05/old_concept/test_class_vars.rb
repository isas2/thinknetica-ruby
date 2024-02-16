module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
    base.class_eval %(@all = [])
  end

  module ClassMethods
    def all
      @all.clone
    end

    def instances
      @all.length
    end

    def inherited(subclass)
      subclass.instance_variable_set("@all", instance_variable_get("@all"))
    end
  end

  module InstanceMethods
    protected
    def register_instance(obj)
      self.class.instance_variable_get("@all") << obj
    end
  end
end

class A
  include InstanceCounter

  def initialize
    register_instance(self)
  end
end

class B < A
end

class C < A
end

class D
  include InstanceCounter

  def initialize
    register_instance(self)
  end
end

def debug(cl)
  class_name = cl.name
  puts "\n------ Class #{class_name} ------"
  puts "#{class_name}.instance_variables #{cl.instance_variables.inspect}"
  puts "#{class_name}.class_variables #{cl.class_variables.inspect}"
  puts "#{class_name}.all #{cl.all}"
  puts "#{class_name}.instances #{cl.instances}"
end

a = A.new
A.all << a  # потенциально опасная ситуация
B.new
B.new
C.new
D.new
debug(A)
debug(B)
debug(C)
debug(D)