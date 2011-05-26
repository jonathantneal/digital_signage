require 'test_helper'

class SlotsControllerTest < ActionController::TestCase
  setup { sign_in @user = users(:admin) }
  teardown { sign_out @user }
  
  test "should get index" do
    get :index, :sign_id => signs(:one).to_param
    assert_response :success
    assert_not_nil assigns(:slots)
  end

  test "should destroy slot" do
    assert_difference('Slot.count', -1) do
      delete :destroy, :id => slots(:one).to_param, :sign_id => signs(:one).to_param
    end

    assert_redirected_to slots_path
  end
  
  test "should sort slots" do
    old_order = Slot.order('`order`').map(&:id)
    put :sort, :slot => old_order.reverse
    new_order = Slot.order('`order`').map(&:id)
    assert_not_equal(old_order, new_order)
  end
end
