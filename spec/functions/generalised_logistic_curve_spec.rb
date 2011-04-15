require 'spec_helper'

describe Reputation::Functions::GeneralisedLogisticCurve do

  it_should_behave_like "any function"

  describe "instance method" do
    describe "'f'" do
      it "should have an adjustable gradient" do
        function_1 = Reputation::Functions::GeneralisedLogisticCurve.new(
          :a => 0,
          :k => 1,
          :b => 1.5,
          :v => 0.5,
          :q => 0.5,
          :m => 0.5
        )
        function_2 = Reputation::Functions::GeneralisedLogisticCurve.new(
          :a => 0,
          :k => 1,
          :b => 0.5,
          :v => 0.1,
          :q => 0.5,
          :m => 15
        )
        function_3 = Reputation::Functions::GeneralisedLogisticCurve.new(
          :a => 0,
          :k => 1,
          :b => 0.5,
          :v => 1.0,
          :q => 0.5,
          :m => 15
        )
                
        function_1.f(0).should be_close(0.23, 0.05)
        function_2.f(0).should be_close(0, 0.05)
        function_3.f(0).should be_close(0, 0.05)
        
        function_1.f(5).should be_close(0.99, 0.05)
        function_2.f(5).should be_close(0, 0.05)
        function_3.f(5).should be_close(0, 0.05)
        
        function_1.f(20).should be_close(1, 0.05)
        function_2.f(20).should be_close(0.66, 0.05)
        function_3.f(20).should be_close(0.96, 0.05)
      end
    end
  end
  
end