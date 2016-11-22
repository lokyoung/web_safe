require 'test_helper'

class CommentOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_a = users(:admin1)
    @comment_1 = comments(:comment_1)
    @comment_2 = comments(:comment_2)
  end

  test "user can add comment to topic" do
    log_in_as @user_1
    # 对话题进行评论
    assert_difference 'Comment.count', 1 do
      post comments_path, params: { type: 'topic', topic_id: 1, comment: { content: 'comment' } }
    end
    assert_equal '评论成功！', flash[:success]
    assert_redirected_to topic_url id: 1

    assert_no_difference 'Comment.count' do
      post comments_path, params: { type: 'topic', topic_id: 1, comment: { content: '' } }
    end
    assert_equal '评论不可为空', flash[:danger]
    assert_redirected_to topic_url id: 1
  end

  test "user can add comment to answer" do
    log_in_as @user_1
    # 对答案进行评论
    assert_difference 'Comment.count', 1 do
      post comments_path, params: { type: 'answer', answer_id: 1, comment: { content: 'comment' } }
    end
    assert_equal '评论成功！', flash[:success]
    assert_redirected_to question_url Answer.find(1).question

    assert_no_difference 'Comment.count' do
      post comments_path, params: { type: 'answer', answer_id: 1, comment: { content: '' } }
    end
    assert_equal '评论不可为空', flash[:danger]
    assert_redirected_to question_url Answer.find(1).question
  end

  test "edit, destroy test" do
    log_in_as @user_1
    patch comment_path @comment_1, params: { comment: { content: 'content1' } }
    assert_redirected_to topic_path @comment_1.topic

    patch comment_path @comment_1, params: { comment: { content: '' } }
    assert_template 'comments/edit'

    patch comment_path @comment_2, params: { comment: { content: 'content2' } }
    assert_redirected_to root_path
    assert_equal '请不要尝试修改他人的内容', flash[:warning]

    assert_difference 'Comment.count', -1 do
      delete comment_path @comment_1
    end
    assert_no_difference 'Comment.count' do
      delete comment_path @comment_2
    end
  end

  test "admin can edit others comment" do
    log_in_as @user_a
    patch comment_path @comment_2, params: { comment: { content: 'content edit' } }
    @comment_2.reload
    assert_equal @comment_2.content, 'content edit'
    assert_redirected_to topic_path @comment_2.topic
  end

  test "admin can destroy others comment" do
    log_in_as @user_a
    assert_difference 'Comment.count', -1 do
      delete comment_path @comment_2
    end
  end
end
