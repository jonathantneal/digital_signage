require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  include Devise::TestHelpers
  
  before (:each) do
    @user = Factory.create(:user)
    sign_in @user
  end
  
  test "should not save department without title" do
    department = Department.new
    assert !department.save, "Saved the department without a title"
  end
end
