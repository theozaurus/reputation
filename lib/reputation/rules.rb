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
    
  private

    def method_missing(name, *args, &block)
      rules.send(name, *args, &block)
    end
    
    def rules
      @rules ||= {}
    end
    
  end
  
  class Rule
    
    attr_accessor :name, :weight, :type
    
    def initialize(name, engine, args={})
      options = {
        :weight => 1,
        :type   => :singular
      }.merge(args)
      
      @name   = name.to_sym
      @weight = options[:weight]
      @type   = options[:type]
      @engine = engine
    end
    
    def normalized_weighting
      BigDecimal(weight.to_s) / @engine.rules.total_weighting 
    end
    
  end
  
end