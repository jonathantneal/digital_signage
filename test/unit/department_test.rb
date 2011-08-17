require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  test "should not save department without title" do
    department = Department.new
    assert !department.save, "Saved the department without a title"
  end
end
