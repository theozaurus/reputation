require 'spec_helper'

describe "User posting messages" do
  
  before do
    @reputation = Reputation.new
    # Two equally weighted rules
    @reputation.rules.add :misc,        :weighting => 1, :kind => :singular
    # Create a new_message rule, where messages over 400 characters are treated positively, and messages lower negatively
    # The aggregate_function is linear with a gradient of 0.2. i.e after 5 positive messages they will reach the maximum
    @reputation.rules.add :new_message, :weighting => 1, 
                                        :kind      => :collection,
                                        :function  => :step,
                                        :constants => { :c => 400 },
                                        :aggregate_function  => :linear,
                                        :aggregate_constants => { :m => 0.2 }
  end
  
  describe "adding good content" do
    
    it "should increase reputation" do      
      expect {
        @reputation.users["bob"].behaviours.add :new_message, 401
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(0.1)
    end
    
  end
  
  describe "adding a good message, then a bad one" do
    
    it "should keep reputation static" do
      @reputation.users["bob"].behaviours.add :new_message, 401

      expect {
        @reputation.users["bob"].behaviours.add :new_message, 401
        @reputation.users["bob"].behaviours.add :new_message, 399
      }.to_not change {
        @reputation.users["bob"].value
      }
    end
    
  end
  
  describe "adding a bad message" do
    
    it "should reduce reputation" do    
      expect {
        @reputation.users["bob"].behaviours.add :new_message, 399
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(-0.5).by_at_most(-0.1)
    end
    
  end
  
  describe "multiple times but not changing content" do
    
    it "should increase reputation" do
      @reputation.users["bob"].behaviours.add :new_message, 401
      
      expect {
        @reputation.users["bob"].behaviours.add :new_message, 401
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(0.1)
    end
    
  end
  
  describe "adding content, then increasing the weighting" do
    
    it "should increase reputation" do
      @reputation.users["bob"].behaviours.add :new_message, 1401   
      
      expect {
        @reputation.rules["new_message"].weight = 2
      }.to change {
        @reputation.users["bob"].value
        # in format of relative weighting * the gradient of the linear aggregate function
      }.from(1/2.0 * 0.2).to(2/3.0 * 0.2) 
    end
    
  end
  
  describe "adding lots of good content" do
   
    it "should not increase reputation past 0.5" do
      @reputation.users["bob"].behaviours.add :new_message, 401
      @reputation.users["bob"].behaviours.add :new_message, 401
      @reputation.users["bob"].behaviours.add :new_message, 401
      @reputation.users["bob"].behaviours.add :new_message, 401
      @reputation.users["bob"].behaviours.add :new_message, 401
      
      # There are 2 rules with equal weighting so value is 0.5
      @reputation.users["bob"].value.should == 0.5
    end
    
  end
  
  describe "adding lots of bad content" do
    
    it "should not decrease reputation past -0.5" do
      @reputation.users["bob"].behaviours.add :new_message, 399
      @reputation.users["bob"].behaviours.add :new_message, 399
      @reputation.users["bob"].behaviours.add :new_message, 399
      @reputation.users["bob"].behaviours.add :new_message, 399   
      @reputation.users["bob"].behaviours.add :new_message, 399
      
      @reputation.users["bob"].value.should == -0.5
    end
    
  end
  
end