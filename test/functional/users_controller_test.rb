require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end
  
  #the method used to check that it shouldn't show user if not logged in
  test "shouldn't show user if not logged in" do
    get :show, id: @user
    assert_response 200
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { id: @user.id }
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    login_as(@user)
    get :show, id: @user
    assert_response :success
  end

end
