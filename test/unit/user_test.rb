require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    @user = users(:one)
    @user2 = users(:two)
  end
  
  #a test to check if a user can be created
  test "a user can be created" do
    assert @user.valid?
  end
  
  test "get the user gender method" do
    assert @user.getGender(@user.id), "getGender of the particular user"
  end
end
