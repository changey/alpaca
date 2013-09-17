require 'test_helper'

class SetLanguageControllerTest < ActionController::TestCase
  
  # the test to check the webpage to switch to English locale when users click English
  test "should get english" do
    get :english
    assert_response :redirect
  end

  # the test to check the webpage to switch to Thai locale when users click Thai
  test "should get thai" do
    get :thai
    assert_response :redirect
  end

  # the test to check the webpage to switch to Taiwanese locale when users click Taiwanese
  test "should get zh_tw" do
    get :zh_tw
    assert_response :redirect
  end

  # the test to check the webpage to switch to Chinese locale when users click Chinese
  test "should get zh_cn" do
    get :zh_cn
    assert_response :redirect
  end

end
