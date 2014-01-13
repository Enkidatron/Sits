require 'test_helper'

class NavigationControllerTest < ActionController::TestCase
  test "should get loose" do
    get :loose
    assert_response :success
  end

  test "should get strict" do
    get :strict
    assert_response :success
  end

end
