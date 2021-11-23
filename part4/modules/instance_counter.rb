module InstanceCounter

  def self.included(base)
    base.extend ClassMethods  
    base.send(:include, InstanceMethods)
  end

  module ClassMethods

    # чтобы инстансы подклассов считались отдкльно, не увеличивая счётчик инстансов родительского класса
    attr_writer :instances

    def instances
      @instances ||= 0   # аналог NVL
    end
  end
  
  module InstanceMethods
      
    protected

    def register_instance
      self.class.instances += 1
    end
  
  end
  
  
      
end