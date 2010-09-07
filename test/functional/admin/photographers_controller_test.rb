require 'test_helper'

class Admin::PhotographersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_photographers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photographer" do
    assert_difference('Admin::Photographer.count') do
      post :create, :photographer => { }
    end

    assert_redirected_to photographer_path(assigns(:photographer))
  end

  test "should show photographer" do
    get :show, :id => admin_photographers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_photographers(:one).to_param
    assert_response :success
  end

  test "should update photographer" do
    put :update, :id => admin_photographers(:one).to_param, :photographer => { }
    assert_redirected_to photographer_path(assigns(:photographer))
  end

  test "should destroy photographer" do
    assert_difference('Admin::Photographer.count', -1) do
      delete :destroy, :id => admin_photographers(:one).to_param
    end

    assert_redirected_to admin_photographers_path
  end
end
