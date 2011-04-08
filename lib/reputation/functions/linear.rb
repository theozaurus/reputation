class Reputation
  class Functions
    class Linear
      
      include Mixin
      
      attr_accessor :m
      
      def initialize(args = {})
        constants = { :m => 1 }.merge( args )
        @m = constants[:m]
      end
      
      def f(x)
        limit x * m
      end
      
    end
    
  end
end