require 'spec_helper'

describe ReputationBehaviour do
  
  before(:each) { 
    @rule = ReputationRule.create!(:name => "foo") 
    @user = User.create!(:name => "bob")
    ReputationBehaviour.create!(:user => @user, :rule => @rule, :metric => 0)
  }

  it { should belong_to :user }
  it { should belong_to :rule }
    
  it { should validate_presence_of :user }
  it { should validate_presence_of :rule }
  it { should validate_numericality_of :metric }

  it { should validate_uniqueness_of( :user_id ).scoped_to(:rule_id) }

  it { should allow_mass_assignment_of :user }
  it { should allow_mass_assignment_of :metric }
  
  it "should allow the rule to be set via a name" do
    ReputationBehaviour.create!(:user => User.create!, :rule => @rule.name, :metric => 0).rule.should eql @rule
  end
  
  it "should allow the rule to be set using a Rule object" do
    ReputationBehaviour.create!(:user => User.create!, :rule => @rule, :metric => 0).rule.should eql @rule
  end
  
  it "should be possible to recalculate a rule without raising an ArgumentError in Rails 3.1" do
    expect { @user.behaviours.first.send :recalculate_rule }.should_not raise_error(ArgumentError) 
  end
  
end