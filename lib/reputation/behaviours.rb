class Reputation
  class BehaviourSet
    
    def initialize(user, engine)
      @user   = user
      @engine = engine
    end
    
    def [](name)
      behaviours[name]
    end
    
    def add(name, metric)
      behaviours[name] = Behaviour.new(name, @user, metric, @engine)
    end
  
  private
  
    def behaviours
      @behaviours ||= {}
    end
    
  end
  
  class Behaviour
    attr_accessor :name, :user, :metric
    
    def initialize(name, user, metric, engine)
      @name   = name
      @user   = user
      @metric = metric
      @engine = engine
      
      @engine.rules[@name].before_new_behaviour_for(@user)
    end
  end
end