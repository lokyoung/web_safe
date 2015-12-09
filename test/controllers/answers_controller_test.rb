require 'test_helper'

class AnswersControllerTest < ActionController::TestCase
  def setup
    @user_1 = users(:user_1)
    @answer_1 = answers(:answer_1)
  end

  test "new" do
    log_in_as @user_1
    assert_difference 'Answer.count', 1 do
      post :create, { question_id: 1, answer: { content: "hh" } }
    end
  end

  test "edit" do
    log_in_as @user_1
    patch :update, { question_id: 1, id: 1, answer: { content: "this is edit" } }
    assert_redirected_to question_url id: 1
    @answer_1.reload
    assert_equal @answer_1.content, "this is edit"
  end
end
