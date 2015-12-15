require 'test_helper'

class StuhomeworkOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
    @homework = homeworks(:homework_1)
    @stuhomework_2 = stuhomeworks(:stuhomework_2)
    @stuhomework_1 = stuhomeworks(:stuhomework_1)
  end

  test "student can edit their own homework" do
    log_in_as @user_1
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test.txt')
    # stuhomework_path方法需要加上括号
    patch stuhomework_path(@stuhomework_1), stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to @stuhomework_1.homework
    @stuhomework_1.reload
    assert_equal @stuhomework_1[:stuhomeworkfile], "test.txt"

    stuhomeworkfile1 = Rack::Test::UploadedFile.new('./test/file/test_2.txt')
    @stuhomework_1.ischecked = true
    @stuhomework_1.save
    patch stuhomework_path(@stuhomework_1), stuhomework: { stuhomeworkfile: stuhomeworkfile1 }
    @stuhomework_1.reload
    assert_equal @stuhomework_1[:stuhomeworkfile], "test.txt"
    assert_equal '已经批改过，无法进行修改', flash[:danger]
    assert_redirected_to @stuhomework_1.homework
  end

  test "student create stuhomework" do
    log_in_as @user_1
    assert_difference 'Stuhomework.count', 1 do
      post homework_stuhomeworks_path(homework_id: @homework.id), stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to @homework
  end

  #test "teacher can check stuhomework" do
    #log_in_as @user_t
    #patch check_complete_stuhomework_path(@stuhomework_1), stuhomework: { mark: 100, remark: '不错'  }
    #assert_redirected_to @stuhomework_1.homework
  #end

end
