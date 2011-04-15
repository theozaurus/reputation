require 'spec_helper'

describe User do
  
  it { should have_many :behaviours }
  
  describe "instance method " do
    describe "#reputation" do
      before(:each){
        @user = User.create! :name => "bob"
        @rule_1 = ReputationRule.create! :name => '1', :weight => 1, :function => 'linear'
        @rule_2 = ReputationRule.create! :name => '2', :weight => 1, :function => 'linear'
        @user.behaviours.create!(:rule => '1', :metric => 1 )
        @user.behaviours.create!(:rule => '2', :metric => 0.5 )
      }
      
      it "should call ReputationRule.value_for" do
        ReputationRule.should_receive(:value_for).with(@user)
        
        @user.reputation
      end
    end
  end
  
end