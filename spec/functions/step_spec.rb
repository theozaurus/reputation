require 'spec_helper'

describe Reputation::Functions::Step do

  it_should_behave_like "any function"

  describe "instance method" do
    
    describe "'f'" do
      it "should have an adjustable step" do
        function_1 = Reputation::Functions::Step.new :c => 1
        function_2 = Reputation::Functions::Step.new :c => 2
        function_3 = Reputation::Functions::Step.new :c => 3
        
        function_1.f(0.99).should eql 0
        function_1.f(1).should eql 1
        
        function_2.f(1.99).should eql 0
        function_2.f(2).should eql 1
        
        function_3.f(2.99).should eql 0
        function_3.f(3).should eql 1
      end
    end
    
  end
  
end