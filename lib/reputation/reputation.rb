class Reputation
  
  def rules
    @rules ||= RuleSet.new(self)
  end
  
  def users
    @users ||= UserSet.new(self)
  end
  
end