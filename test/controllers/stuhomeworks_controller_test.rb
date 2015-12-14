require 'test_helper'

class StuhomeworksControllerTest < ActionController::TestCase
  def setup
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
    @homework = Homework.create user_id: @user_t.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    @stuhomework_1 = Stuhomework.create homework_id: @homework.id, user_id: @user_1.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @stuhomework_2 = Stuhomework.create homework_id: @homework.id, user_id: @user_2.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_2.txt')
  end

  test "student create homework and edit" do
    log_in_as @user_1
    #assert_difference 'Stuhomework.count', 1 do
    #post :create, homework_id: @homework.id, stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    #end

    # 可以成功修改自己的作业
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #stuhomeworkfile = fixture_file_upload('file/test_1.txt')
    patch :update, id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to @homework
    @stuhomework_1.reload
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_1.txt"

    # 会引发callback，让值回复原始值
    #@stuhomework_1.update_attributes(ischecked: true)
    @stuhomework_1.update_columns(ischecked: true)
    patch :update, id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_2.txt') }
    @stuhomework_1.reload
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_1.txt"
    assert_equal '已经批改过，无法进行修改', flash[:danger]
    assert_redirected_to @stuhomework_1.homework
  end

  test "can not edit others" do
    log_in_as @user_1
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    patch :update, id: @stuhomework_2.id, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to root_url
  end

  test "admin can edit others" do
    log_in_as @user_a
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    patch :update, id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: stuhomeworkfile }
    assert_redirected_to @homework
    @stuhomework_1.reload
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_1.txt"
  end

  test "student can't check their homework" do
    log_in_as @user_1
    get :check, id: @stuhomework_1.id
    assert_redirected_to root_url
    assert_equal '权限不够，无法操作', flash[:warning]

    patch :check_complete, id: @stuhomework_1.id, stuhomework: { mark: 100, remark: '不错' }
    assert_redirected_to root_url
    assert_equal '权限不够，无法操作', flash[:warning]
  end

  test "teacher and admin can check stuhomework" do
    log_in_as @user_t
    patch :check_complete, id: @stuhomework_1.id, stuhomework: { mark: 100, remark: '不错' }
    @stuhomework_1.reload
    assert_redirected_to @homework
    assert_equal @stuhomework_1.mark, 100
    assert_equal @stuhomework_1.remark, '不错'
  end

end
