require "spec_helper"

describe Reputation::RuleSet do
  
  subject {
    Reputation::RuleSet.new(Reputation.new)
  }
  
  describe "initializing" do
    
    it "should require an engine" do
      expect {
        Reputation::RuleSet.new()
      }.to raise_error(ArgumentError)
      
      Reputation::RuleSet.new(Reputation.new)
    end
        
  end
    
  it_should_be_enumerable
    
  describe "instance method" do
    
    describe "add" do
      it "should create a new rule" do
        r = subject.add :foo, :weighting => 1
        r.should be_a Reputation::Rule
      end
      
      it "should added to the collection" do
        subject.add :foo
        subject.add :bar
        subject.keys.size == 2
        subject.keys.should include :foo
        subject.keys.should include :bar
      end
    end
    
    describe "[name]" do
      it "should return the rule matching name" do
        r = subject.add :foo, :weighting => 1
        subject[:foo].should equal r
      end
      
      it "should return the rule matching name when a string" do
        r = subject.add :foo, :weighting => 1
        subject['foo'].should equal r
      end
      
      it "should return nil if no rule is found" do
        subject[:made_up].should be_nil
      end
    end
    
    describe "total_weighting" do
      it "should add up the weight of each rule" do
        expect {
          subject.add :foo, :weight => 2.1
          subject.add :bar, :weight => 1.0
        }.to change {
          subject.total_weighting
        }.from(0).to(3.1)
      end
    end
        
  end
  
end