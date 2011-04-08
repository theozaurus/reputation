require "googlecharts"
require "launchy"

class Reputation
  class Functions
    module Mixin
      
      def google_chart_url
        range = Array.new(200){|i| i * 0.1 }
        c = Googlecharts.line(
          :size => '800x200',
          :axis_with_labels => 'x,y',
          :title => self.class.name,
          :data => range.map{|x| f(x)},
          :axis_range => [[range.first,range.last],[0,1]]
        )
      end
      
      def google_chart
        Launchy::Browser.run google_chart_url
      end
      
    end
    
  end
end