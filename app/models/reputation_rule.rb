class ReputationRule < ActiveRecord::Base
  
  has_many :intermediate_values, :class_name => 'ReputationIntermediateValue', :foreign_key => 'rule_id'
  has_many :behaviours,          :class_name => 'ReputationBehaviour',         :foreign_key => 'rule_id'
  
  serialize :constants,           Hash
  serialize :aggregate_constants, Hash

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :weight, :only_integer => true, :greater_than => 0
  
  attr_accessible :name, :kind, :weight, :function, :constants, :aggregate_function, :aggregate_constants
  
  attr_readonly :kind
  
  def initialize(*args)
    args[0] = {
      :weight => 1,
      :kind => 'singular',
      :function => 'linear',
      :constants => { :m => 1 },
      :aggregate_function => 'linear',
      :aggregate_constants => { :m => 1 }
    }.merge(args.first||{})

    super *args
  end
  
  # Return the total score for a certain user
  #
  # @param [User]
  def self.value_for(user)
    all.inject(0){|total,r| total + r.value_for( user ) }
  end
  
  # Lookup the weighting relative to all other rules
  #
  def normalized_weighting
    BigDecimal(weight.to_s) / ReputationRule.sum('weight')
  end
  
  # Calculate the score for a certain user
  #
  # @param [User]
  def value_for(user)
    behaviour = user.behaviours.find_by_rule_id id
    if behaviour
      case kind
      when 'singular'
        f(behaviour.metric) * normalized_weighting
      when 'collection'
        ivo = intermediate_values.find_by_user_id_and_name(user.id,kind)
        iv = ivo ? ivo.value : 0
        aggregate_f( 
          f(behaviour.metric) + iv
        ) * normalized_weighting
      end
    else
      0
    end
  end
  
  # Return the function object defined by :function and :constants
  #
  # @return [Reputation::Functions::Linear, Reputation::Functions::Step, Reputation::Functions::GeneralisedLogisticCurve]
  def function
    build_function(super, constants)
  end
  
  # Return the aggregate function object defined by :aggregate_function and :aggregate_constants
  #
  # @return [Reputation::Functions::Linear, Reputation::Functions::Step, Reputation::Functions::GeneralisedLogisticCurve]
  def aggregate_function
    build_function(super, aggregate_constants)
  end
  
  def recalculate_intermediate_values_for(user) # :nodoc:
    behaviour = user.behaviours.find_by_rule_id(self.id)
    if behaviour
      case kind
      when 'collection'
        iv = intermediate_values.find_by_user_id_and_name(user.id,kind) || intermediate_values.build(:user => user, :name => kind)
        iv.value += f(behaviour.metric)
        iv.save!
      end
    end
  end
  
private

  # Delegate f to the function#f
  def f(*args)
    function.f(*args)
  end
  
  # Delegate aggregate_f to the aggregate_function#f
  def aggregate_f(*args)
    aggregate_function.f(*args)
  end

  def build_function(name, constants)
    klass = "Reputation::Functions::#{name.to_s.camelcase}".constantize
    klass.new(constants)
  end
  
end