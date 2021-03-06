require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                               email: "user@qq",
                               password: "123",
                               password_confirmation: "456" } }
    end
    assert_template 'users/new'
  end

  test "valid signup" do
    get signup_path
    assert_no_difference 'User.count', 1 do
      post users_path, params: { user: { name: "hehe",
                               email: "example@qq.com",
                               password: "123456",
                               password_confirmation: "123456" } }
    end
  end
end
