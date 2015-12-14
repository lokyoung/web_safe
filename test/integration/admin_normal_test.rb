require 'test_helper'

class AdminAnnounceTest < ActionDispatch::IntegrationTest
  def setup
    log_in_as users(:admin1)
  end

  test "edit announce" do
    get edit_admin_announce_path(id: 1)
    assert_select "div.panel-heading", text: "公告修改"
    assert_response :success

    patch admin_announce_path(id: 1), announce: { title: "update",
                                                  cotent: "update content" }
    assert_redirected_to admin_announces_url

    patch admin_announce_path(id: 1), announce: { title: "",
                                                  cotent: "update content" }
    assert_select "div.panel-heading", text: "公告修改"
    assert_response :success
  end

  test "delete announce" do
    assert_difference 'Announce.count', -1 do
      delete admin_announce_path id: 1
    end
  end

  test "edit user" do
    user = User.find(1)
    get edit_admin_user_path id: 1
    assert_select "div.panel-heading", text: "用户信息修改"
    assert_response :success

    patch admin_user_path id: 1, user: { name: "admin" }
    assert_redirected_to admin_users_url
    user.reload
    assert_equal user.name, "admin"
  end

  test "delete user" do
    assert_difference 'User.count', -1 do
      delete admin_user_path id: 1
    end
    assert_redirected_to admin_users_url
  end

  test "edit question" do
    question = Question.find(1)
    get edit_admin_question_path id: 1
    assert_select "div.panel-heading", text: "问题修改"
    assert_response :success

    patch admin_question_path(question), question: { issolved: true }
    assert_redirected_to admin_questions_url
    question.reload
    assert_equal question.issolved, true
  end

  test "delete question" do
    assert_difference 'Question.count', -1 do
      delete admin_question_path id: 1
    end
    assert_redirected_to admin_questions_url
  end

  test "edit answers" do
    answer = Answer.find(1)
    get edit_admin_question_answer_path question_id: 1, id: 1
    assert_select "div.panel-heading", text: "答案修改"
    assert_response :success

    patch admin_question_answer_path(question_id:1, id: 1), answer: { content: 'edit' }
    answer.reload
    assert_equal answer.content, 'edit'
  end

  test "delte answers" do
    answer = Answer.find(1)
    qid = answer.question.id
    assert_difference 'Answer.count', -1 do
      delete admin_question_answer_path question_id: 1, id: 1
    end
    assert_redirected_to admin_question_answers_url question_id: qid
  end
end
