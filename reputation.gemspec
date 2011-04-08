Gem::Specification.new do |s|
  s.name        = "reputation"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.author      = "Theo Cushion"
  s.email       = "theo.c@zepler.net"
  s.homepage    = "http://github.com/theozaurus/reputation"
  s.summary     = "Designed to help manage reputations based on user behavior"
  s.description = "reputation is designed to help calculate reputation scores based on user behaviour and rules that are easily editable."
 
  s.required_rubygems_version = ">= 1.3.6"
  
  s.add_dependency 'googlecharts'
  s.add_dependency 'launchy'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.4'
  
  s.files        = Dir.glob("lib/**/*") + %w()
  s.test_files   = Dir.glob("spec/**/*") + %w(.rspec .infinity_test)
  s.require_path = 'lib'
end