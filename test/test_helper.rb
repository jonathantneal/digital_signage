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
  def set_current_user(user)
    session['cas'] = { 'user' => user.try(:username), 'extra_attributes' => {} }
  end

  def unset_current_user
    session['cas'] = nil
  end

  def as_user(user, &block)
    begin
      set_current_user users(user)
      yield
    ensure
      unset_current_user
    end
  end
end

require 'declarative_authorization/maintenance'

class Test::Unit::TestCase
  include Authorization::TestHelper
end