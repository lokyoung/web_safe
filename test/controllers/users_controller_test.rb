require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:user_1)
  end

  test "get user new" do
    get :new
    assert_response :success
  end

  test "user edit" do
    log_in_as @user
    assert_response :success
    patch :update, id: @user.id, user: { name: 'aha' }
    assert_redirected_to @user
  end
end
