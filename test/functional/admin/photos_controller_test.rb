require 'test_helper'

class Admin::PhotosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create photo" do
    assert_difference('Admin::Photo.count') do
      post :create, :photo => { }
    end

    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should show photo" do
    get :show, :id => admin_photos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_photos(:one).to_param
    assert_response :success
  end

  test "should update photo" do
    put :update, :id => admin_photos(:one).to_param, :photo => { }
    assert_redirected_to photo_path(assigns(:photo))
  end

  test "should destroy photo" do
    assert_difference('Admin::Photo.count', -1) do
      delete :destroy, :id => admin_photos(:one).to_param
    end

    assert_redirected_to admin_photos_path
  end
end
