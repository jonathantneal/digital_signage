require 'test_helper'

class SlideTest < ActiveSupport::TestCase

  def setup
    @slide = slides(:one)
  end

  test "wont save an unpublish date before a publish date" do
    @slide.update_attributes :publish_at => 1.day.from_now, :unpublish_at => 1.day.ago
    assert !@slide.save
  end

  test "will save a unpublish date after a publish date" do
    @slide.update_attributes :publish_at => 1.day.ago, :unpublish_at => 1.day.from_now
    assert @slide.save
  end

  test "blank publish dates are considered unpublished" do
    @slide.update_attributes :publish_at => nil, :unpublish_at => nil
    assert @slide.unpublished?
  end

  test "blank publish date and a past unpublish date should be considered unpublished" do
    @slide.update_attributes :publish_at => nil, :unpublish_at => 1.day.ago
    assert @slide.unpublished?
  end

  test "blank publish date and a future unpublish date should be considered published" do
    @slide.update_attributes :publish_at => nil, :unpublish_at => 1.day.from_now
    assert @slide.published?
  end

  test "past publish date and a blank unpublish date should be considered published" do
    @slide.update_attributes :publish_at => 1.day.ago, :unpublish_at => nil
    assert @slide.published?
  end
  
  test "future publish date and a blank unpublish date should be considered unpublished" do
    @slide.update_attributes :publish_at => 1.day.from_now, :unpublish_at => nil
    assert @slide.unpublished?
  end

  test "past publish dates should be considered unpublished" do
    @slide.update_attributes :publish_at => 2.days.ago, :unpublish_at => 1.day.ago
    assert @slide.unpublished?
  end

  test "future publish dates should be considered unpublished" do
    @slide.update_attributes :publish_at => 1.day.from_now, :unpublish_at => 2.days.from_now
    assert @slide.unpublished?
  end

  test "past publish date and a future unpublish date should be considered published" do
    @slide.update_attributes :publish_at => 1.day.ago, :unpublish_at => 1.day.from_now
    assert @slide.published?
  end
  
  test "published count plus unpublished count should equal total slide count" do
    assert Slide.published.count + Slide.unpublished.count == Slide.count
  end

  test "default value for delay is actually being set" do
    slide = Slide.new
    assert slide.delay == AppConfig.defaults.slide.delay
  end

end
