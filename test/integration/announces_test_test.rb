require 'test_helper'

class AnnouncesTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user_t = users(:teacher1)
    @announce_1 = announces(:announce_1)
  end

  test "announce list" do
    get root_path
    assert_template 'announces/index'
    assert_select 'title', '首页 | 花椒网安'
  end

  test "announce detail" do
    log_in_as(@user_t)
    get announce_path @announce_1
    assert_response :success
    assert_template 'announces/show'
    assert_select "title", "#{@announce_1.title} | 花椒网安"
  end

  test "user can crud announce" do
    log_in_as @user_t
    get announce_path @announce_1
    assert_response :success
    assert_select 'title', full_title(@announce_1.title)

    get new_announce_path
    assert_response :success
    assert_select 'title', full_title('发布公告')

    assert_difference 'Announce.count', 1 do
      post_via_redirect announces_path, announce: { title: "new", content: "haha" }
    end
    assert_equal '发布公告成功！', flash[:success]
    # assert_select 'title', full_title('自由讨论')

    # 访问修改页面
    get edit_announce_path @announce_1
    assert_response :success
    assert_template 'announces/edit'
    assert_select 'title', full_title('公告修改')

    patch announce_path @announce_1, announce: { title: "update", content: "update" }
    assert_redirected_to @announce_1

    patch announce_path @announce_1, announce: { title: "", content: "update" }
    assert_template 'announces/edit'

    assert_difference 'Announce.count', -1 do
      # delete_via_redirect announce_path id: 1
      delete announce_path id: 1
    end
    #assert_response :success
    assert_redirected_to announces_url
    follow_redirect!
    assert_equal '公告删除成功！', flash[:success]
    assert_template 'announces/index'
  end

end
