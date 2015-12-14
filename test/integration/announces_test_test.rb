require 'test_helper'

class AnnouncesTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user_1 = users(:user_1)
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

  test "student can see the announce" do
    log_in_as @user_1
    get announce_path @announce_1
    assert_response :success
    assert_template 'announces/show'
    assert_select "title", "#{@announce_1.title} | 花椒网安"
  end

  test "student can not do some options on announce" do
    log_in_as @user_1

    post announces_path, announce: { title: "new", content: "haha" }
    assert_redirected_to root_url
    get edit_announce_path @announce_1
    assert_redirected_to root_url

    patch announce_path @announce_1, announce: { title: "update", content: "update" }
    assert_redirected_to root_url
  end

  test "user can create announce" do
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
    assert_select 'title', full_title('首页')
  end

  test "user can edit their own announce" do
    log_in_as @user_t
    # 访问修改页面
    get edit_announce_path @announce_1
    assert_response :success
    assert_template 'announces/edit'
    assert_select 'title', full_title('公告修改')

    # 有效修改
    patch announce_path @announce_1, announce: { title: "update", content: "update" }
    assert_redirected_to @announce_1
    @announce_1.reload
    assert_equal "update", @announce_1.title

    @announce_1.update_attributes(title: "update1")
    assert_equal "update1", @announce_1.title

    # 无效修改
    patch announce_path @announce_1, announce: { title: "", content: "update" }
    assert_template 'announces/edit'
  end

  test "user can delete announce" do
    log_in_as @user_t
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
