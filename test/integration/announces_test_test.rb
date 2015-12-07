require 'test_helper'

class AnnouncesTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:example)
  end

  test "announces list" do
    get root_path
    assert_template 'announces/index'
    assert_select 'title', '首页 | 花椒网安'
  end
end
