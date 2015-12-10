require 'test_helper'

class AnswerOptionTest < ActionDispatch::IntegrationTest

  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:admin1)
    @answer_1 = answers(:answer_1)
    @answer_2 = answers(:answer_2)
  end

  test "user add and delete answer" do
    log_in_as @user_1
    get question_path id: 1
    assert_response :success
    assert_template 'questions/show'
    assert_difference 'Answer.count', 1 do
      post_via_redirect question_answers_path(question_id: 1), answer: { content: 'hah' }
    end
    assert_equal '创建答案成功', flash[:success]
    assert_template 'questions/show'
    assert_no_difference 'Answer.count' do
      post question_answers_path(question_id: 1), answer: { content: '' }
    end
    assert_equal '答案不可为空', flash[:danger]
    assert_difference 'Answer.count', -1 do
      delete answer_path id: 1
    end
    assert_redirected_to question_url id: 1
    assert_no_difference 'Answer.count' do
      delete answer_path id: 2
    end
  end

  test "user can edit their own answer but can not edit others" do
    log_in_as @user_1
    get edit_answer_path id: 1
    assert_response :success
    assert_template 'answers/edit'
    get edit_answer_path id: 2
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'announces/index'
    content = "edit as user1"
    patch answer_path id: 2, answers: { content: content }
    assert_redirected_to root_url
    assert_equal @answer_2.content, "user 2"
  end

  test "admin user can edit and destroy others" do
    log_in_as @user_2
    get edit_answer_path id: 1
    assert_response :success
    assert_difference 'Answer.count', -1 do
      delete answer_path id: 1
    end
    assert_redirected_to question_url id: 1
    content = "edit as user admin"
    patch answer_path id: 2, answer: { content: content }
    assert_redirected_to question_url id: 1
    @answer_2.reload
    assert_equal @answer_2.content, content
  end

end
