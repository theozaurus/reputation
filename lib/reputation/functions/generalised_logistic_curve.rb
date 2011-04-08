class Reputation
  class Functions
    class GeneralisedLogisticCurve
      
      include Mixin
      
      attr_accessor :a, :k, :b, :v, :q, :m
      
      def initialize(args = {})
        constants = { 
          :a => -1,  # lower asymptote
          :k => 1,   # upper asymptote
          :b => 10,  # growth rate
          :v => 0.5, # affects near which asymptote maximum growth occurs
          :q => 0.5, # depends on the value Y(0)
          :m => 0, # the time of maximum growth if Q=v
        }.merge( args )
        @a = constants[:a]
        @k = constants[:k]
        @b = constants[:b]
        @v = constants[:v]
        @q = constants[:q]
        @m = constants[:m]
      end
      
      def f(t)
        limit( 
          a.to_f + (
            (k.to_f - a.to_f) /
            (1 + q.to_f * Math.exp(-1 * b.to_f*(t.to_f-m.to_f)) )**(1.to_f/v.to_f)
          )
        )
      end
      
    end
  end
end