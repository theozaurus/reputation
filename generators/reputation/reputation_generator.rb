class ReputationGenerator < Rails::Generator::Base
  
  def manifest
    
    record do |m|
      m.migration_template "reputation_create_tables.rb", "db/migrate", :migration_file_name => "reputation_create_tables"
    end
    
  end
  
end