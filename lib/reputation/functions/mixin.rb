require "googlecharts"
require "launchy"

class Reputation
  class Functions
    module Mixin
      
      # Produces the URL for a google chart of the function
      #
      def google_chart_url
        points = 1000
        range = Array.new(points){|i| (i-points/2) * 0.01 }
        y = range.map{|x| f(x) }
        c = Googlecharts.line(
          :size => '800x200',
          :axis_with_labels => 'x,y',
          :title => self.class.name,
          :data => y,
          :axis_range => [[range.first,range.last],[y.min,y.max]]
        )
      end
      
      # Opens the google chart for the function in the browser
      #
      def google_chart
        Launchy::Browser.run google_chart_url
      end
    
    private
      
      def limit(r)
        if r > 1
          1
        elsif r < -1
          -1
        else
          r
        end
      end
      
    end
    
  end
end