require "spec_helper"

describe Reputation::Rule do
  
  before do
    @engine = Reputation.new 
  end
  
  subject {
    @engine.rules.add :name, :weight => 1
    @engine.rules[:name]
  }
  
  describe "initializing" do
    
    it "should require a name and engine" do
      expect {
        Reputation::Rule.new(:rule_name)
      }.to raise_error(ArgumentError)
      
      Reputation::Rule.new(:rule_name, Reputation.new)
    end
  
    it "should allow optional arguments" do
      r = Reputation::Rule.new(:rule_name, Reputation.new, {
        :weight    => 4,
        :function  => :generalised_logistic_curve,
        :constants => {
          :b => 2
        }
      })
      
      r.weight.should == 4
      r.function.should be_a Reputation::Functions::GeneralisedLogisticCurve
      r.function.b.should == 2
    end
    
  end
  
  it_should_not_have_methods :name=, :type=
  
  describe "instance method" do
    
    describe "function" do
      it "should return the function" do
        Reputation::Rule.new(:rule_name, Reputation.new, :function => :step).function.should be_a Reputation::Functions::Step
      end
    end
    
    describe "function=" do
      it "should set the function" do
        subject.function = Reputation::Functions::Linear.new
        subject.function.should be_a Reputation::Functions::Linear
      end
    end
    
    describe "normalized_weighting" do
      it "should be 1 if there are no other rules" do
        subject.weight = 200
        subject.normalized_weighting.should eql 1
      end
      
      it "should calculate the normalized weighting if there are other rules" do
        
      end
    end
    
    describe "name" do
      it "should return the name of the rule as a symbol" do
        Reputation::Rule.new(:rule_name, Reputation.new).name.should eql :rule_name
        Reputation::Rule.new('rule_name', Reputation.new).name.should eql :rule_name
      end
    end
    
    describe "weight" do
      it "should return the name of the rule as a symbol" do
        Reputation::Rule.new(:rule_name, Reputation.new, :weight => 2).weight.should eql 2
      end
    end
    
    describe "type" do
      it "should return the name of the rule as a symbol" do
        Reputation::Rule.new(:rule_name, Reputation.new, :type => :singular).type.should eql :singular
      end
    end
    
    describe "weight=" do
      it "should change the weight" do
        subject.weight = 5
        subject.weight.should eql 5
      end
      
      it "should alter the normalized_weight" do
        @engine.rules.add :another_rule, :weight => 1
        
        # Going from 1 part in 2, to 3 parts in 4
        expect {
          subject.weight = 3
        }.to change {
          subject.normalized_weighting
        }.from(0.5).to(0.75)
      end
    end
    
  end
  
end