class Reputation  
  module User
    
    def self.included(model)
      model.send(:include, InstanceMethods)
      model.send(:include, Relations)
    end
    
    module Relations
      def self.included(model)
        model.class_eval do
          
          has_many :behaviours, :class_name => "ReputationBehaviour", :extend => AddRails2 if Reputation::RailsVersion.rails_2?
          has_many :behaviours, :class_name => "ReputationBehaviour", :extend => AddRails3 if Reputation::RailsVersion.rails_3?
          
        end
      end
    end
    
    module AddRails2
      def add(rule, metric)
        rule = ReputationRule.find_by_name rule unless rule.is_a? ReputationRule
        b = proxy_reflection.klass.find_by_user_id_and_rule_id proxy_owner.id, rule.id
        b ||= proxy_reflection.klass.new :rule => rule, :user => proxy_owner
        b.update_attribute :metric, metric
        proxy_owner.behaviours(true)
        b
      end
    end
    
    module AddRails3
      def add(rule, metric)
        rule = ReputationRule.find_by_name rule unless rule.is_a? ReputationRule
        b = reflection.klass.find_by_user_id_and_rule_id owner.id, rule.id
        b ||= reflection.klass.new :rule => rule, :user => owner
        b.update_attribute :metric, metric
        owner.behaviours(true)
        b
      end
    end
    
    module InstanceMethods
      
      # Returns the reputation value for the user
      #
      def reputation
        ReputationRule.value_for(self)
      end
    end
    
  end
end