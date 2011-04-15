ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/rails_root/config/environment")

$:.unshift File.expand_path(File.dirname(File.dirname(__FILE__)))

require 'reputation'
require 'shoulda'
require 'spec/rails'
Spec::Runner.configure do |config|
  # config
end

Dir.glob('spec/helpers/*.rb') do |f|
  require f
end