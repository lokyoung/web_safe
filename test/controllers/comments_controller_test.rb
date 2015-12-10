require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  def setup
    @user_1 = users(:user_1)
    @comment_1 = comments(:comment_1)
  end

  test "edit" do
    log_in_as @user_1
    patch :update, { id: 1, comment: { content: "edit!" } }
  end
end
