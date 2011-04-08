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
                
        function_1.f(0).should be_within(0.05).of(0.23)
        function_2.f(0).should be_within(0.05).of(0)
        function_3.f(0).should be_within(0.05).of(0)
        
        function_1.f(5).should be_within(0.05).of(0.99)
        function_2.f(5).should be_within(0.05).of(0)
        function_3.f(5).should be_within(0.05).of(0)
        
        function_1.f(20).should be_within(0.05).of(1)
        function_2.f(20).should be_within(0.05).of(0.66)
        function_3.f(20).should be_within(0.05).of(0.96)
      end
    end
  end
  
end