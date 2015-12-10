require 'test_helper'

class StuhomeworkOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
    @homework = Homework.create user_id: @user_t.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @stuhomework = Stuhomework.create user_id: @user_1.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @stuhomework = Stuhomework.create user_id: @user_2.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "student create homework and edit" do
    log_in_as @user_1
    assert_difference 'Stuhomework.count', 1 do
      post homework_stuhomeworks_path(homework_id: @homework.id), stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_1.txt') }
    end
    assert_response :redirect
  end
end
