# module for discription instance counter
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  # module for discription instance counter for class methods
  module ClassMethods
    def instances
      @instances ||= 0
    end

    attr_writer :instances
  end

  # module for discription instance counter for instance methods
  module InstanceMethods
    protected

    def register_instance
      self.class.instances += 1
    end
  end
end
