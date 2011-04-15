class ReputationBehaviour < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :rule, :class_name => 'ReputationRule'
  
  before_save :recalculate_rule
  
  attr_accessible :user, :rule, :metric
  
  validates_presence_of :user
  validates_presence_of :rule
  validates_numericality_of :metric
  
  validates_uniqueness_of :user_id, :scope => :rule_id
  
  # Set the rule, can either be a ReputationRule or the name of the rule
  #
  # @example
  #   behaviour.rule = 'rule_1'
  #   # or
  #   behaviour.rule = ReputationRule.find(:first)
  
  def rule=(rule)
    write_attribute :rule_id, case rule
    when ReputationRule
      rule.id
    else 
      ReputationRule.find_by_name( rule ).try(:id)
    end
  end
  
private

  def recalculate_rule
    rule.recalculate_intermediate_values_for user
  end
  
end