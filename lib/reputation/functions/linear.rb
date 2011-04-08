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
        r = x * m
        if r > 1
          1
        elsif r < 0
          0
        else
          r
        end
      end
      
    end
    
  end
end