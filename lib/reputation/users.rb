class Reputation
  class UserSet
    
    def initialize(engine)
      @engine = engine
    end
    
    def [](name)
      users[name] ||= User.new(name, engine)
    end
    
  private
    
    def users
      @users ||= {}
    end
    
    def engine
      @engine
    end
  end
  
  class User
    attr_reader :name
    
    def initialize(name, engine)
      @name   = name
      @engine = engine
    end
    
    def value
      engine.rules.inject(0){|value, (name,rule)|
        b = behaviours[name]
        value += b.metric * rule.normalized_weighting if b
        value
      }
    end
    
    def behaviours
      @behaviours ||= BehaviourSet.new
    end
    
  private
  
    def engine
      @engine
    end
    
  end
end