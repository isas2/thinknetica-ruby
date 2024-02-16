module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
    base.send :init
  end

  module ClassMethods
    def all
      @all.clone
    end

    def instances
      @all.length
    end

    def inherited(subclass)
      instance_var = "@all"
      subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
    end

    protected
    
    def init
      @all = []
    end

    def add(obj)
      @all << obj
    end

    def delete(obj)
      @all.delete(obj)
    end
  end

  module InstanceMethods
    protected
    def register_instance(obj)
      self.class.send :add, obj
    end
  end
end