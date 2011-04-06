class Reputation
  class BehaviourSet
    
    def [](name)
      behaviours[name]
    end
    
    def add(name, args={})
      behaviours[name] = Behaviour.new(name, args)
    end
  
  private
  
    def behaviours
      @behaviours ||= {}
    end
    
  end
  
  class Behaviour
    attr_accessor :name, :metric
    
    def initialize(name, metric)
      @name   = name
      @metric = metric
    end
  end
end