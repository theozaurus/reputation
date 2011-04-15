class ReputationCreateTables < ActiveRecord::Migration
  def self.up
    create_table :reputation_rules do |t|
      t.string  :name
      t.integer :weight
      t.string  :kind
      t.string  :function
      t.string  :constants
      t.string  :aggregate_function
      t.string  :aggregate_constants      
    end

    create_table :reputation_intermediate_values do |t|
      t.references :user
      t.references :rule
      t.string     :name
      t.decimal    :value
    end
    add_index :reputation_intermediate_values, :user_id
    add_index :reputation_intermediate_values, :rule_id
    add_index :reputation_intermediate_values, :name

    create_table :reputation_behaviours do |t|
      t.references :user
      t.references :rule
      t.decimal    :metric
    end
    add_index :reputation_behaviours, :user_id
    add_index :reputation_behaviours, :rule_id
  end

  def self.down
    drop_table :reputation_rules
    drop_table :reputation_user_rule
    drop_table :reputation_behaviours
  end
end
