require 'spec_helper'

describe Reputation::Functions::Linear do

  it_should_behave_like "any function"

  describe "instance method" do    
    describe "'f'" do
      it "should have an adjustable gradient" do
        function_1 = Reputation::Functions::Linear.new :m => 1
        function_2 = Reputation::Functions::Linear.new :m => 2
        function_3 = Reputation::Functions::Linear.new :m => 3
        
        function_1.f(0.25).should eql 0.25
        function_2.f(0.25).should eql 0.5
        function_3.f(0.25).should eql 0.75
      end
    end
  end
  
end