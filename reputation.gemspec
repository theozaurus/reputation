Gem::Specification.new do |s|
  s.name        = "reputation"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.author      = "Theo Cushion"
  s.email       = "theo.c@zepler.net"
  s.homepage    = "http://github.com/theozaurus/reputation"
  s.summary     = "Designed to help manage reputations based on user behavior"
  s.description = "reputation is designed to help calculate reputation scores based on user behaviour and rules that are easily editable."
 
  s.required_rubygems_version = ">= 1.3.6"
  
  s.add_dependency 'googlecharts'
  s.add_dependency 'launchy'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails', '~> 1.3'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'rails', '2.3.11'
  
  s.files        = Dir.glob("{lib,app,generators,rails}/**/*")
  s.test_files   = Dir.glob("{spec}/**/*") + %w(.rspec .infinity_test)
  s.require_path = 'lib'
end