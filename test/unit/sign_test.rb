require 'test_helper'

class SignTest < ActiveSupport::TestCase
  test "shouldn't save with weird name characters" do
    sign = signs(:one)
    sign.name = 'Son of a &@$*#!'
    assert !sign.save
  end
end
