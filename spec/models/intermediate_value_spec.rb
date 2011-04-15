require 'spec_helper'

describe ReputationIntermediateValue do

  before(:each) { 
    rule = ReputationRule.create!(:name => "foo")
    user = User.create!(:name => "bob")
    ReputationIntermediateValue.create!(:rule => rule, :user => user, :name => "foo")
  }

  it { should belong_to :user }
  it { should belong_to :rule }
    
  it { should validate_presence_of :user }
  it { should validate_presence_of :rule }
  it { should validate_numericality_of :value }

  it { should validate_uniqueness_of( :name ).scoped_to(:user_id, :rule_id) }

  it { should allow_mass_assignment_of :user }
  it { should allow_mass_assignment_of :rule }
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :value }
  
  it "should set value to 0 by default" do
    subject.value.should eql 0
  end
  
end