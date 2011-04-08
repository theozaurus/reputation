class Reputation
  class Functions
    class Step
      
      include Mixin
      
      attr_accessor :a, :k, :c
      
      def initialize(args = {})
        constants = {
          :a => -1,  # lower asymptote
          :k => 1,   # upper asymptote
          :c => 0.5  # point of switch
        }.merge( args )
        @c = constants[:c]
        @k = constants[:k]
        @a = constants[:a]
      end
      
      def f(x)
        limit( x.to_f >= c.to_f ? k : a )
      end
      
    end
    
  end
end