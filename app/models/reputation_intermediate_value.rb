class ReputationIntermediateValue < ActiveRecord::Base
    
  belongs_to :user
  belongs_to :rule, :class_name => 'ReputationRule'
  
  validates_presence_of :user
  validates_presence_of :rule
  validates_numericality_of :value
  
  validates_uniqueness_of :name, :scope => [:user_id, :rule_id]
  
  attr_accessible :user, :rule, :name, :value
  
  def initialize(args = {})
    options = {
      :value => 0
    }.merge(args)

    super options
  end
    
end