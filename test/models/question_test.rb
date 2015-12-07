require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @question = @user.questions.build(title: "Quesiton", content: "This is a question.")
  end

  test "normal valid" do
    assert @question.valid?
  end

  test "title can't be blank" do
    @question.title = ""
    assert_not @question.valid?
  end

  test "content can't be blank" do
    @question.content = ""
    assert_not @question.valid?
  end
end
