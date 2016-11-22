require 'test_helper'

class TopicOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_a = users(:admin1)
    @topic_1 = topics(:topic_1)
    @topic_2 = topics(:topic_2)
  end

  test "user can create topic" do
    log_in_as @user_1
    get topic_path @topic_1
    assert_response :success
    assert_select 'title', full_title(@topic_1.title)

    get new_topic_path
    assert_response :success
    assert_select 'title', full_title('发布新话题')

    assert_difference 'Topic.count', 1 do
      post topics_path, params: { topic: { title: "new", content: "haha" } }
    end
    follow_redirect!
    assert_equal '发布话题成功', flash[:success]
    assert_select 'title', full_title('自由讨论')
  end

  test "user can edit their topic" do
    log_in_as @user_1
    # 访问修改页面
    get edit_topic_path @topic_1
    assert_response :success
    assert_template 'topics/edit'
    assert_select 'title', full_title('修改话题')

    patch topic_path @topic_1, params: { topic: { title: "update", content: "update" } }
    assert_redirected_to @topic_1
    assert_equal '修改话题成功', flash[:success]

    patch topic_path @topic_1, params: { topic: { title: "", content: "update" } }
    assert_template 'topics/edit'

  end

  test "user can delete their topic" do
    log_in_as @user_1
    assert_difference 'Topic.count', -1 do
      # delete_via_redirect topic_path id: 1
      delete topic_path id: 1
    end
    follow_redirect!
    assert_response :success
    #assert_redirected_to topics_url
    assert_equal '话题删除成功', flash[:success]
    assert_template 'topics/index'
    assert_select 'title', full_title('自由讨论')
  end

  test "user can not edit others" do
    log_in_as @user_1
    get edit_topic_path @topic_2
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]

    patch topic_path @topic_2, params: { topic: { title: "update", content: "update" } }
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]
  end

  test "user can not delete others" do
    log_in_as @user_1
    assert_no_difference 'Topic.count' do
      delete topic_path @topic_2
    end
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]
  end

  test "admin can edit others" do
    log_in_as @user_a
    get edit_topic_path @topic_2
    assert_response :success
    assert_select 'title', full_title('修改话题')
    assert_template 'topics/edit'

    patch topic_path @topic_2, params: { topic: { title: "update", content: "update" } }
    assert_redirected_to @topic_2
    assert_equal '修改话题成功', flash[:success]

  end

  test "admin can destroy others" do
    log_in_as @user_a
    assert_difference 'Topic.count', -1 do
      delete topic_path id: 2
    end
    assert_redirected_to topics_url
    follow_redirect!
    assert_equal '话题删除成功', flash[:success]
    assert_template 'topics/index'
    assert_select 'title', full_title('自由讨论')
  end
end
