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

  test "edit and delete user" do
    user = User.find(1)
    get edit_admin_user_path id: 1
    assert_select "div.panel-heading", text: "用户信息修改"
    assert_response :success

    patch admin_user_path id: 1, user: { name: "admin" }
    assert_redirected_to admin_users_url
    user.reload
    assert_equal user.name, "admin"

    assert_difference 'User.count', -1 do
      delete admin_user_path id: 1
    end
  end

  test "edit and delete question" do
    question = Question.find(1)
    get edit_admin_question_path id: 1
    assert_select "div.panel-heading", text: "问题修改"
    assert_response :success

    patch admin_question_path(question), question: { issolved: true }
    assert_redirected_to admin_questions_url
    question.reload
    assert_equal question.issolved, true
  end
end
