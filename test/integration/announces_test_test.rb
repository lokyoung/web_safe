require 'test_helper'

class AnnouncesTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:example)
    @announce = announces(:announce_1)
  end

  test "announce list" do
    get root_path
    assert_template 'announces/index'
    assert_select 'title', '首页 | 花椒网安'
  end

  test "announce detail" do
    log_in_as(@user)
    get announce_path @announce
    assert_response :success
    assert_template 'announces/show'
    assert_select "title", "#{@announce.title} | 花椒网安"
  end
end
