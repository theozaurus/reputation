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
      engine.rules.value(name)
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