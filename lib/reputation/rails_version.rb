class Reputation
  class RailsVersion
    
    def self.rails_3?
      defined?(Rails) && Rails::VERSION::MAJOR == 3
    end
    
    def self.rails_2?
      defined?(Rails) && Rails::VERSION::MAJOR == 2
    end
    
  end
end
