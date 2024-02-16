module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @counter
    end
  end

  module InstanceMethods
    protected

    def register_instance
      counter = self.class.instance_variable_get("@counter") + 1
      self.class.instance_variable_set("@counter", counter)
    end
  end
end