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
    
    def value(behaviors)
      rules.inject(0){|value,(name,rule)|
        value += rule.value behaviors[name]
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
    
    attr_reader :name, :type
    attr_accessor :weight, :function
    
    def initialize(name, engine, args={})
      options = {
        :weight    => 1,
        :type      => :singular,
        :function  => :linear,
        :constants => { :m => 1 }
      }.merge(args)
      
      @name     = name.to_sym
      @weight   = options[:weight]
      @type     = options[:type]
      @function = build_function(options[:function], options[:constants])
      @engine = engine
    end
    
    # Look up total rule weighting, and provide normalised weighting
    def normalized_weighting
      BigDecimal(weight.to_s) / @engine.rules.total_weighting 
    end
    
    def value(behavior)
      behavior ? f(behavior.metric) * normalized_weighting : 0
    end
    
    # Delegate f to the function
    def f(*args)
      function.f(*args)
    end
    
  private
  
    def build_function(name, constants)
      # Mimic a bit of active support to turn :generalised_logistic_curve into
      # Reuptation::Functions::GeneralisedLogisticCurve
      klass = Reputation::Functions.const_get name.to_s.split('_').map(&:capitalize).join
      klass.new(constants)
    end
    
  end
  
end