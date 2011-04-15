require 'spec_helper'

describe "User updating a profile by" do
  
  before do
    @user = User.create! :name => 'bob'
    
    # Two equally weighted rules
    ReputationRule.create :name => 'misc',           :weighting => 1, :kind => 'singular'
    ReputationRule.create :name => 'profile_update', :weighting => 1, :kind => 'singular'
  end
  
  describe "adding content" do
    
    it "should increase reputation" do      
      expect {
        @user.behaviours.add 'profile_update', 0.5
      }.to change {
        @user.reputation
      }.by_at_least(0.1)
    end
    
  end
  
  describe "adding content and then removing" do
    
    it "should keep reputation static" do
      @user.behaviours.add 'profile_update', 0.5

      expect {
        @user.behaviours.add 'profile_update', 0.7
        @user.behaviours.add 'profile_update', 0.5
      }.to_not change {
        @user.reputation
      }
    end
    
  end
  
  describe "adding content and then removing more" do
    
    it "should reduce reputation" do
      @user.behaviours.add 'profile_update', 0.5
      
      expect {
        @user.behaviours.add 'profile_update', 0.7
        @user.behaviours.add 'profile_update', 0.3
      }.to change {
        @user.reputation
      }.by_at_least(-0.5).by_at_most(-0.1)
    end
    
  end
  
  describe "multiple times but not changing content" do
    
    it "should keep reputation static" do
      @user.behaviours.add 'profile_update', 0.7
      
      expect {
        @user.behaviours.add 'profile_update', 0.7
        @user.behaviours.add 'profile_update', 0.7
      }.to_not change {
        @user.reputation
      }
    end
    
  end
  
  describe "adding content, then increasing the weighting" do
    
    it "should increase reputation" do
      @user.behaviours.add 'profile_update', 1    
      
      expect {
        ReputationRule.find_by_name('profile_update').update_attribute :weight, 2
      }.to change {
        @user.reputation
      }.by_at_least(0.1)
    end
    
  end
  
end