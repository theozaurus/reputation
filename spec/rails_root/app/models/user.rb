class User < ActiveRecord::Base
  include Reputation::User
end
