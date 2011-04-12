require "bigdecimal"

class Reputation
  
  class RuleSet
    
    def initialize(engine)
      @engine = engine
    end
    
    def add(name, args={})
      rules[name.to_sym] = Rule.new name, @engine, args
    end
    
    def [](name)
      rules[name.to_sym]
    end
    
    def total_weighting
      rules.inject(0){|t,(name,rule)| rule.weight + t }
    end
    
    def value(user)
      rules.inject(0){|value,(name,rule)|
        value += rule.value user
      }
    end
    
  private

    def method_missing(name, *args, &block)
      rules.send(name, *args, &block)
    end
    
    def rules
      @rules ||= {}
    end
    
  end
  
  class Rule
    
    attr_reader :name, :kind
    attr_accessor :weight, :function, :aggregate_function
    
    def initialize(name, engine, args={})
      options = {
        :weight    => 1,
        :kind      => :singular,
        :function  => :linear,
        :constants => { :m => 1 },
        :aggregate_function => :linear,
        :aggregate_constants => { :m => 1 }
      }.merge(args)
      
      @name     = name.to_sym
      @weight   = options[:weight]
      @kind     = options[:kind]
      @function = build_function(options[:function], options[:constants])
      @aggregate_function = build_function(options[:aggregate_function], options[:aggregate_constants])
      @engine = engine
    end
    
    # Look up total rule weighting, and provide normalised weighting
    def normalized_weighting
      BigDecimal(weight.to_s) / @engine.rules.total_weighting 
    end
    
    def value(user)
      behaviour = behaviour_for user
      if behaviour
        case kind
        when :singular
          f(behaviour.metric) * normalized_weighting
        when :collection
          aggregate_f( 
            f(behaviour.metric) + intermediate_values_for(user)[:collection]
          ) * normalized_weighting
        end
      else
        0
      end
    end
    
    def before_new_behaviour_for(user)
      behaviour = behaviour_for user
      case kind
      when :collection
        intermediate_values_for(user)[:collection] += f(behaviour.metric) if behaviour
      end
    end
    
  private
  
    # Delegate f to the function#f
    def f(*args)
      function.f(*args)
    end
  
    # Delegate aggregate_f to the aggregate_function#f
    def aggregate_f(*args)
      aggregate_function.f(*args)
    end
  
    def intermediate_values_for(user)
      (@intermediate_values ||= {})[user] ||= begin
        hash = {}
        hash.default = 0
        hash
      end
    end
    
    def behaviour_for(user)
      @engine.users[user].behaviours[name]
    end
  
    def build_function(name, constants)
      # Mimic a bit of active support to turn :generalised_logistic_curve into
      # Reuptation::Functions::GeneralisedLogisticCurve
      klass = Reputation::Functions.const_get name.to_s.split('_').map(&:capitalize).join
      klass.new(constants)
    end
    
  end
  
end