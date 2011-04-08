class Reputation
  class Functions
    class Step
      
      include Mixin
      
      attr_accessor :c
      
      def initialize(args = {})
        constants = { :c => 0.5 }.merge( args )
        @c = constants[:c]
      end
      
      def f(x)
        x.to_f >= c.to_f ? 1 : 0
      end
      
    end
    
  end
end