require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  setup { sign_in @user = users(:manager) }
  teardown { sign_out @user }

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create slide" do
    assert_difference('Slide.count') do
      post :create, :slide => { :title => 'JUST CREATED', :resize => 'none', :user_id => users(:manager).id }
    end

    assert_redirected_to slide_path(assigns(:slide))
  end

  test "should show slide" do
    get :show, :id => slides(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => slides(:one).to_param
    assert_response :success
  end

  test "should update slide" do
    put :update, :id => slides(:one).to_param, :slide => { :title => 'UPDATED' }
    assert_redirected_to slide_path(assigns(:slide))
  end

  test "should destroy slide" do
    assert_difference('Slide.count', -1) do
      delete :destroy, :id => slides(:one).to_param
    end

    assert_redirected_to slides_path
  end
end
