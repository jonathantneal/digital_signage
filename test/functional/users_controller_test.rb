require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup { set_current_user users(:admin) }
  teardown { unset_current_user }

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should create user" do
    AppConfig.security.validate_usernames = false

    assert_difference('User.count') do
      post :create, :user => { :username=>'keysersoze' }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => users(:manager).to_param
    assert_response :success
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => users(:manager).to_param
    end

    assert_redirected_to users_path
  end
end
