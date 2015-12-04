require 'test_helper'

class MainLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "layout" do
    get root_path
    assert_template 'announces/index'
    #assert_select "a[herf=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    get signup_path
    assert_select "title", full_title("用户注册")
  end
end
