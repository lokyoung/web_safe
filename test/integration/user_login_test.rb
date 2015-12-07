require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example)
  end

  test "invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "valid login and logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: @user.email, password: '123456' }
    assert is_logged_in?
    # 检查重定向地址是否正确
    assert_redirected_to root_url
    # 由于登录之后发生了重定向，所以需要follow_redirect访问重定向的地址
    follow_redirect!
    assert_template 'announces/index'
    assert_select "a[href=?]", login_path, count: 0
    #assert_select "a[href=?]", logout_path, count: 1
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path
    # 如果之前一次请求是重定向，返回true
    redirect?
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
  end
end
