require 'spec_helper'

describe "User updating a profile by" do
  
  before do
    @reputation = Reputation.new
    # Two equally weighted rules
    @reputation.rules.add :misc,           :weighting => 1, :kind => :singular
    @reputation.rules.add :profile_update, :weighting => 1, :kind => :singular
  end
  
  describe "adding content" do
    
    it "should increase reputation" do      
      expect {
        @reputation.users["bob"].behaviours.add :profile_update, 0.5
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(0.1)

    end
    
  end
  
  describe "adding content and then removing" do
    
    it "should keep reputation static" do
      @reputation.users["bob"].behaviours.add :profile_update, 0.5

      expect {
        @reputation.users["bob"].behaviours.add :profile_update, 0.7
        @reputation.users["bob"].behaviours.add :profile_update, 0.5
      }.to_not change {
        @reputation.users["bob"].value
      }
    end
    
  end
  
  describe "adding content and then removing more" do
    
    it "should reduce reputation" do
      @reputation.users["bob"].behaviours.add :profile_update, 0.5
      
      expect {
        @reputation.users["bob"].behaviours.add :profile_update, 0.7
        @reputation.users["bob"].behaviours.add :profile_update, 0.3
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(-0.5).by_at_most(-0.1)
    end
    
  end
  
  describe "multiple times but not changing content" do
    
    it "should keep reputation static" do
      @reputation.users["bob"].behaviours.add :profile_update, 0.7
      
      expect {
        @reputation.users["bob"].behaviours.add :profile_update, 0.7
        @reputation.users["bob"].behaviours.add :profile_update, 0.7
      }.to_not change {
        @reputation.users["bob"].value
      }
    end
    
  end
  
  describe "adding content, then increasing the weighting" do
    
    it "should increase reputation" do
      @reputation.users["bob"].behaviours.add :profile_update, 1    
      
      expect {
        @reputation.rules["profile_update"].weight = 2
      }.to change {
        @reputation.users["bob"].value
      }.by_at_least(0.1)
    end
    
  end
  
end