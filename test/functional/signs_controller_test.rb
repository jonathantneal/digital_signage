require 'test_helper'

class SignsControllerTest < ActionController::TestCase
  test "should get index" do
    as_user(:manager) do
      get :index
      assert_response :success
      assert_not_nil assigns(:signs)
    end
  end

  test "should get new" do
    as_user(:admin) do
      get :new
      assert_response :success
    end
  end

  test "should create sign" do
    as_user(:admin) do
      assert_difference('Sign.count') do
        post :create, :sign => { :name => 'just_created', :title => 'Just Created' }
      end

      assert_redirected_to sign_path(assigns(:sign))
    end
  end

  test "should show sign" do
    as_user(:manager) do
      get :show, :id => signs(:one).to_param
      assert_response :success
    end
  end

  test "should show sign xml" do
    get :show, :id => signs(:one).to_param, :format => :xml
    assert_response :success
  end

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

  test "should destroy sign" do
    as_user(:admin) do
      assert_difference('Sign.count', -1) do
        delete :destroy, :id => signs(:one).to_param
      end

      assert_redirected_to signs_path
    end
  end
end
