require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @user4 = users(:user_1)
    @question = Question.find 1
    @question2 = Question.find 2
  end

  test "can just watch, can not create, update and destroy before login" do
    get :index
    assert_response :success
    assert_template 'questions/index'
    get :show, id: 1
    assert_response :success
    get :new
    assert_redirected_to login_url
    get :edit, id: 1
    assert_redirected_to login_url
    post :create, question: { title: "haha", content: "ok" }
    assert_redirected_to login_url
    patch :update, id: 1, question: { title: "haha", content: "ok" }
    assert_redirected_to login_url
  end

  test "user can crud" do
    log_in_as @user4
    get :edit, id: 1
    assert_response :success
    assert_template 'questions/edit'
    assert_difference 'Question.count', 1 do
      post :create, question: { title: "haha", content: "ok" }
    end
    assert flash.present?
    assert_redirected_to questions_url
    patch :update, id: 1, question: { title: "hah", content: "okl", issolved: true }
    assert_redirected_to @question
    @question.reload
    assert_equal @question.title, "hah"
    assert_equal @question.content, "okl"
    assert_equal @question.issolved, true
    assert_difference 'Question.count', -1 do
      delete :destroy, id: 1
    end
    assert_redirected_to questions_url
    assert flash.present?
  end

  test "invalid edit by student" do
    log_in_as @user4
    patch :update, id: 1, question: { title: "", content: "okl", issolved: true }
    assert_equal @question.title, "question"
    assert_template 'questions/edit'
    get :edit, id: 2
    assert_redirected_to root_url
    patch :update, id: 2, question: { title: "hah", content: "okl", issolved: true }
    assert_redirected_to root_url
  end

  test "invalid edit by teacher" do
    log_in_as @user2
    get :edit, id: 2
    assert_redirected_to root_url
    patch :update, id: 2, question: { title: "hah", content: "okl", issolved: true }
    assert_redirected_to root_url
  end

  test "admin user can edit and destroy other" do
    log_in_as @user3
    get :edit, id: 2
    assert_response :success
    assert_template 'questions/edit'
    patch :update, id: 2, question: { title: "hah", content: "okl", issolved: true }
    assert_redirected_to @question2
    @question2.reload
    assert_equal @question2.title, "hah"
    assert_equal @question2.content, "okl"
    assert_equal @question2.issolved, true
    assert_difference 'Question.count', -1 do
      delete :destroy, id: 1
    end
    assert_redirected_to questions_url
  end
end
