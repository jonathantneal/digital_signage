require 'test_helper'

class SlotsControllerTest < ActionController::TestCase

  test "should destroy slot" do
    as_user(:admin) do
      assert_difference('Slot.count', -1) do
        post :destroy_multiple, :slot => [slots(:one).id.to_s], :format => 'js'
      end
    end
  end
  
  test "should sort slots" do
    as_user(:admin) do
      old_order = Slot.order('`order`').map(&:id)
      put :sort, :slot => old_order.reverse
      new_order = Slot.order('`order`').map(&:id)
      assert_not_equal(old_order, new_order)
    end
  end

  test "manager should destroy only slots of signs he owns" do
    as_user(:manager_one) do
      post :destroy_multiple, :slot => [slots(:one).id.to_s, slots(:two).id.to_s], :format => 'js'

      assert_raises ActiveRecord::RecordNotFound, "first slot should be deleted because user had permission to" do
        Slot.find(slots(:one))
      end
      assert Slot.find(slots(:two)), "manager deleted a slot he didn't have access too"
    end
  end

end
