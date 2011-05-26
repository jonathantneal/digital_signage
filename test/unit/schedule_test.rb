require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  test "shouldnt save schedule with bogus time" do
    schedule = schedules(:one)
    schedule.when = 'Moonday'
    assert !schedule.save
  end
end
