require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "get user new" do
    get :new
    assert_response :success
  end
end
