require 'test_helper'

class AnnouncesTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user_1 = Fabricate(:student)
    @user_t = Fabricate(:teacher)
    @announce_1 = Fabricate(:announce_1)
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

    post announces_path, params: { announce: { title: "new", content: "haha" } }
    assert_redirected_to root_url
    get edit_announce_path @announce_1
    assert_redirected_to root_url

    patch announce_path @announce_1, params: { announce: { title: "update", content: "update" } }
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
      post announces_path, params: { announce: { title: "new", content: "haha" } }
      follow_redirect!
    end
    assert_equal '发布公告成功！', flash[:success]
    assert_select 'title', full_title('首页')
  end

  test "user can edit their own announce" do
    log_in_as @user_t
    # 访问修改页面
    # 这里测试时会返回302而不是200，但是加入断点之后，get edit_announce_path @announce_1
    # 返回200，之后的测试可以通过
    # binding.pry
    get edit_announce_path @announce_1
    assert_response :success
    assert_template 'announces/edit'
    assert_select 'title', full_title('公告修改')

    # 有效修改
    patch announce_path @announce_1, params: { announce: { title: "update", content: "update" } }
    assert_redirected_to @announce_1
    @announce_1.reload
    assert_equal "update", @announce_1.title

    @announce_1.update_attributes(title: "update1")
    assert_equal "update1", @announce_1.title

    # 无效修改
    patch announce_path @announce_1, params: { announce: { title: "", content: "update" } }
    assert_template 'announces/edit'
  end

  test "user can delete announce" do
    log_in_as @user_t
    assert_difference 'Announce.count', -1 do
      # delete_via_redirect announce_path id: 1
      delete announce_path id: @announce_1.id
    end
    #assert_response :success
    assert_redirected_to announces_url
    follow_redirect!
    assert_equal '公告删除成功！', flash[:success]
    assert_template 'announces/index'
  end

end
