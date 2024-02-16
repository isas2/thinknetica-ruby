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