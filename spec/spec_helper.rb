$:.unshift File.join(File.dirname(File.dirname(__FILE__)),'lib')

require 'reputation'

RSpec.configure do |config|
  config.expect_with :rspec
  config.mock_with   :rspec
end