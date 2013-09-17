# require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  #the method used to check it should destroy a session
  test "should destroy session" do
    get :destroy
    assert_response :redirect
  end
  
  #the method used to check if the page redirect to the Facebook authentication page
  test "should redirect to facebook check authentication page" do
    get :new
    assert_response :redirect
  end

end
