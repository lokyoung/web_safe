require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @question = announces(:question)
  end
end
