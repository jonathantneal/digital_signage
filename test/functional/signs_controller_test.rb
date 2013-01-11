require 'test_helper'

class SignsControllerTest < ActionController::TestCase

  #### Index
  test "should get index" do
    as_user(:manager) do
      get :index
      assert_response :success
      assert_not_nil assigns(:signs)
    end
  end

  ### Create
  test "admin should get new" do
    as_user(:admin) do
      get :new
      assert_response :success
    end
  end
  
  test "manager should not get new" do
    as_user(:admin) do
      get :new
      assert_response :success
    end
  end

  test "admin should create sign" do
    as_user(:admin) do
      assert_difference('Sign.count') do
        post :create, :sign => { :name => 'just_created', :title => 'Just Created', :department_id => 1, :full_screen_mode => 'fullscreen', :transition_duration => 1.0, :reload_interval => 300, :check_in_interval => 180}
      end

      assert_redirected_to sign_path(assigns(:sign))
    end
  end


  ### Show
  test "should show sign" do
    as_user(:admin) do
      get :show, :id => signs(:one).to_param
      assert_response :success
    end
  end

  test "should show sign json" do
    get :show, :id => signs(:one).to_param, :format => :json
    assert_response :success
  end


  ### Update
  test "should get edit" do
    as_user(:admin) do
      get :edit, :id => signs(:one).to_param
      assert_response :success
    end
  end

  test "should update sign" do
    as_user(:admin) do
      put :update, :id => signs(:one).to_param, :sign => { }
      assert_redirected_to sign_path(assigns(:sign))
    end
  end



  ### Destroy
  test "admin should destroy sign" do
    as_user(:admin) do
      assert_difference('Sign.count', -1) do
        delete :destroy, :id => signs(:one).to_param
      end

      assert_redirected_to signs_path
    end
  end
  test "manager should not destroy sign" do
    as_user(:manager_one) do
      assert_no_difference('Sign.count') do
        delete :destroy, :id => signs(:one).to_param
      end
    end
  end
  
  
  ### Check-In
  test "guest should check-in to sign" do
    get :check_in, :id => signs(:one).to_param
    assert_response :success
  end
  
end
