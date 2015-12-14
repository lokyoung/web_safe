require 'test_helper'

class StuhomeworkOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
    @homework = Homework.create user_id: @user_t.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @stuhomework_1 = Stuhomework.create homework_id: @homework.id, user_id: @user_1.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @stuhomework_2 = Stuhomework.create user_id: @user_2.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "student create homework and edit before check" do
    log_in_as @user_1
    assert_difference 'Stuhomework.count', 1 do
      post homework_stuhomeworks_path(homework_id: @homework.id), stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to @homework

    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test.txt')
    patch stuhomework_path @stuhomework_1, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to @homework
    @homework.reload
    #assert_equal @stuhomework_1[:stuhomeworkfile], "test_1.txt"

    patch stuhomework_path @stuhomework_2, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to root_url

    @stuhomework_1.ischecked = true
    @stuhomework_1.save
    @stuhomework_1.reload
    patch stuhomework_path @stuhomework_1, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_equal '已经批改过，无法进行修改', flash[:danger]
    assert_redirected_to @stuhomework_1.homework
  end

end
