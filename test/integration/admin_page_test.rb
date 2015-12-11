require 'test_helper'

class AdminPageTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
  end

  test "student can't get admin page" do
    log_in_as @user_1
    get admin_root_path
    assert_redirected_to root_url
  end

  test "teacher can't get admin page" do
    log_in_as @user_t
    get admin_root_path
    assert_redirected_to root_url
  end

  test "admin can get admin page" do
    log_in_as @user_a
    get admin_root_path
    assert_response :success
  end

end
