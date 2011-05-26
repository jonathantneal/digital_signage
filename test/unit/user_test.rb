require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "shouldnt save user who doesnt exist" do
    AppConfig.security.validate_usernames = true
    assert !User.new(:username => 'keysersoze').save
  end
end
