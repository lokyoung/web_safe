require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:user_1)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @user4 = Fabricate(:user)
  end

  test "fabricator user" do
    log_in_as @user4
    get :edit, id: @user4.id
    assert_response :success
  end

  test "get user new" do
    get :new
    assert_response :success
  end

  test "user edit their own profile" do
    log_in_as @user1
    get :edit, id: @user1.id
    assert_response :success
    patch :update, id: @user1.id, user: { name: 'aha' }
    assert_redirected_to @user1
  end

  test "user edit fail" do
    log_in_as @user1
    get :edit, id: @user1.id
    assert_response :success
    patch :update, id: @user1.id, user: { name: "" }
    assert_template 'users/edit'
  end

  test "normal user can't edit other user" do
    log_in_as @user1
    get :edit, id: @user2.id
    assert_redirected_to root_url
    patch :update, id: @user2.id, user: { name: "aha" }
    assert_redirected_to root_url
  end

  test "teacher user can't edit other user" do
    log_in_as @user2
    get :edit, id: @user1.id
    assert_redirected_to root_url
    patch :update, id: @user1.id, user: { name: "aha" }
    assert_redirected_to root_url
  end

  test "admin user can edit other user" do
    log_in_as @user3
    get :edit, id: @user2.id
    assert_response :success
    patch :update, id: @user2.id, user: { name: "aha" }
    assert_redirected_to @user2
  end

end
