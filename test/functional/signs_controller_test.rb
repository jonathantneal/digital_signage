require 'test_helper'

class SignsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:signs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sign" do
    assert_difference('Sign.count') do
      post :create, :sign => { }
    end

    assert_redirected_to sign_path(assigns(:sign))
  end

  test "should show sign" do
    get :show, :id => signs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => signs(:one).to_param
    assert_response :success
  end

  test "should update sign" do
    put :update, :id => signs(:one).to_param, :sign => { }
    assert_redirected_to sign_path(assigns(:sign))
  end

  test "should destroy sign" do
    assert_difference('Sign.count', -1) do
      delete :destroy, :id => signs(:one).to_param
    end

    assert_redirected_to signs_path
  end
end
