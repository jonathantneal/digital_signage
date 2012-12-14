require 'test_helper'

class SlidesControllerTest < ActionController::TestCase
  setup { set_current_user users(:manager) }
  teardown { unset_current_user }


  ### Index
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:slides)
  end


  ### Create
  test "should get new" do
    get :new
    assert_response :success
  end

  test "admin should create slide" do
    as_user(:admin) do
      assert_difference('Slide.count') do
        slide_file = fixture_file_upload('files/slide1.png', 'image/png')
        post :create, :slide => { :title => 'JUST_CREATED', :content => slide_file, :resize => 'none', :delay => 5, :color => "000000", :department_id => departments(:one).to_param}
      end

      assert_redirected_to slide_path(assigns(:slide))
    end
  end

  test "manager one should create slide with department one" do
    as_user(:manager_one) do
      assert_difference('Slide.count') do
        slide_file = fixture_file_upload('files/slide1.png', 'image/png')
        post :create, :slide => { :title => 'JUST_CREATED_again', :content => slide_file, :resize => 'none', :delay => 5, :color => "000000", :department_id => departments(:one).to_param}
      end

      assert_redirected_to slide_path(assigns(:slide))
    end
  end


  ### Show
  test "manager one should show slide one" do
    as_user(:manager_one) do
      get :show, :id => slides(:one).to_param
      assert_response :success
    end
  end


  ### Edit/update
  test "manager one should get edit slide one" do
    as_user(:manager_one) do
      get :edit, :id => slides(:one).to_param
      assert_response :success
    end
  end
  test "manager one should NOT get edit slide two" do
    as_user(:manager_one) do
      get :edit, :id => slides(:two).to_param
      assert_response 403
    end
  end

  test "manager two should update slide two" do
    as_user(:manager_two) do
      put :update, :id => slides(:two).to_param, :slide => { :title => 'UPDATED' }
      assert_redirected_to slide_path(assigns(:slide))
    end
  end


  ### Destroy
  test "admin should destroy slide" do
    as_user(:admin) do
      assert_difference('Slide.count', -1) do
        delete :destroy, :id => slides(:one).to_param
      end
      assert_redirected_to slides_path
    end
  end
end
