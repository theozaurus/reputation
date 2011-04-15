require "spec_helper"

describe ReputationRule do
  
  subject{ ReputationRule.create! :name => "test" }
  
  it { should have_many :intermediate_values }
  it { should have_many :behaviours }
  
  it { should validate_presence_of :name }
  it {
    ReputationRule.create! :name => "wibble"
    should validate_uniqueness_of :name
  }
  it { should validate_numericality_of :weight }
  
  it { should allow_mass_assignment_of :name }
  it { should allow_mass_assignment_of :kind }
  it { should allow_mass_assignment_of :weight }
  it { should allow_mass_assignment_of :function }
  it { should allow_mass_assignment_of :constants }
  it { should allow_mass_assignment_of :aggregate_function }
  it { should allow_mass_assignment_of :aggregate_constants }

  describe "initializing" do
    it "should allow optional arguments" do
      r = ReputationRule.create!(
        :name      => 'foo',
        :weight    => 4,
        :function  => 'generalised_logistic_curve',
        :constants => {
          :b => 2
        },
        :aggregate_function  => 'step',
        :aggregate_constants => {
          :c => 20
        }
      )
      
      r.weight.should == 4
      r.function.should be_a Reputation::Functions::GeneralisedLogisticCurve
      r.function.b.should == 2
      r.aggregate_function.should be_a Reputation::Functions::Step
      r.aggregate_function.c.should == 20
    end
    
    describe "defaults" do      
      it { subject.weight.should eql 1 }
      it { subject.function.should be_a Reputation::Functions::Linear }
      it { subject.constants.should eql({ :m => 1 }) }
      it { subject.aggregate_function.should be_a Reputation::Functions::Linear }
      it { subject.aggregate_constants.should eql({ :m => 1 }) }
    end
  end

  describe "instance method " do
    
    describe "#function" do
      
      it "should return a function object" do
        subject.function.should be_a Reputation::Functions::Linear
      end
      
      it "should depend on function attribute" do
        subject.function = 'step'
        subject.function.should be_a Reputation::Functions::Step
      end
      
      it "should depend on constants attribute" do
        subject.constants = {:m => 2.2}
        subject.function.m.should eql 2.2
      end
      
    end
    
    describe "#aggregate_function" do
      
      it "should return a function object" do
        subject.aggregate_function.should be_a Reputation::Functions::Linear
      end
      
      it "should depend on function attribute" do
        subject.aggregate_function = 'step'
        subject.aggregate_function.should be_a Reputation::Functions::Step
      end
      
      it "should depend on constants attribute" do
        subject.aggregate_constants = {:m => 2.2}
        subject.aggregate_function.m.should eql 2.2
      end
      
    end
    
    describe "#normalized_weighting" do
      it "should be 1 if there are no other rules" do
        subject.update_attribute :weight, 200
        
        subject.normalized_weighting.should eql 1
      end
      
      it "should calculate the normalized weighting if there are other rules" do      
        ReputationRule.create :name => 'foo', :weight => 1
        
        subject.normalized_weighting.should eql 1/2.0
        
        ReputationRule.create :name => 'bar', :weight => 2
        
        subject.normalized_weighting.should eql 1/4.0
      end
    end
    
    describe "#weight=" do      
      it "should alter the normalized_weight when saved" do
        ReputationRule.create :name => :another_rule, :weight => 1
        
        # Going from 1 part in 2, to 3 parts in 4
        expect {
          subject.weight = 3
          subject.save
        }.to change {
          subject.normalized_weighting
        }.from(0.5).to(0.75)
      end
      
      it "should alter the normalized_weight when a new rule is added" do
      
        # Going from 1 part in 1, to 1 parts in 3
        expect {
          ReputationRule.create :name => :new_rule, :weight => 2
        }.to change {
          subject.normalized_weighting
        }.from(1).to(1/3.0)
      end
    end
    
    describe "#value_for" do
      describe "when kind is singular" do
        
        before(:each){ 
          @rule = ReputationRule.create! :name => 'rule', :weight => 1, :kind => 'singular'
          
          @user = User.create! :name => 'bob'
          @user.behaviours.add 'rule', 0.5
        }
  
        it "should return the value based on the metric considering the normalised weighting" do
          expect {
            # Create another rule with equal weighting
            ReputationRule.create! :name => 'other', :weight => 1
          }.to change {
            @rule.value_for @user
          }.from(0.5).to(0.25)
        end
  
        it "should return the value based on the metric considering the squashing function" do
          expect {
            @rule.function = :linear
            @rule.constants = { :m => 2 }
            @rule.save
          }.to change {
            @rule.value_for @user
          }.from(0.5).to(1.0)
        end
      end
      
      describe "when kind is collection" do
        before(:each){
          @rule = ReputationRule.create! :name => 'rule', 
                                         :weight => 1,
                                         :kind => 'collection',
                                         :function  => 'linear',
                                         :constants => { :m => 1 },
                                         :aggregate_function  => 'linear',
                                         :aggregate_constants => { :m => 0.1 }
          
          @user = User.create! :name => 'bob'
          @user.behaviours.add 'rule', 0.5
        }
        
        it "should return the value based on the metric considering the normalised weighting" do
          expect {
            ReputationRule.create :name => 'other', :weight => 1
          }.to change {
            @rule.value_for @user
          }.from(1 * 0.5 * 1 * 0.1).to(0.5 * 0.5 * 1 * 0.1)
        end
        
        it "should return the value based on the metric considering the squashing function" do
          expect {
            @rule.function = 'linear'
            @rule.constants = { :m => 2 }
            @rule.save
          }.to change {
            @rule.value_for @user
          }.from(0.05).to(0.1)
        end
        
        it "should return the value based on previous metrics" do
          expect {
            @user.behaviours.add 'rule', 0.5
          }.to change {
            @rule.value_for @user
            # Normalized weight, metric, gradient, aggregate_gradient + intermediate_value
          }.from(1 * 0.5 * 1 * 0.1 + 0).to( 1 * 0.5 * 1 * 0.1 + (0.5 * 1 * 0.1))
        end
        
      end
    end
    
  end
  
  describe "class method " do
    
    describe "#value_for" do
      
      it "should sum all of the values for each rule for array of behaviors" do
        ReputationRule.create! :name => 'rule 1', :weight => 1
        ReputationRule.create! :name => 'rule 2', :weight => 1
        ReputationRule.create! :name => 'rule 3', :weight => 1
        
        @user = User.create! :name => 'bob'
        
        @user.behaviours.add 'rule 1', 1.0
        @user.behaviours.add 'rule 2', -0.25
         
        ReputationRule.value_for( @user ).should == (1/3.0 - 0.25/3.0)
      end
            
    end
    
  end
  
end