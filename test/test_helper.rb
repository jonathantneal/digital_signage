ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def as_user(user, &block)
    begin
      sign_in :user, users(user)
      yield
    ensure
      sign_out :user
    end
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end

require 'declarative_authorization/maintenance'

class Test::Unit::TestCase
  include Authorization::TestHelper
end
