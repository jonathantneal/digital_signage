require 'test_helper'

class SlideTest < ActiveSupport::TestCase
  test "shouldnt save slide with bad url" do
    slide = slides(:one)
    slide.uri = 'http://bogusdomain42.com/bogus.jpg'
    assert !slide.save
  end
end
