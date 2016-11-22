require 'test_helper'

class StuhomeworksControllerTest < ActionController::TestCase
  def setup
    @user_1 = users(:user_1)
    @user_t = users(:teacher1)
    @user_a = users(:admin1)
    #@stuhomework_1 = Stuhomework.create! homework_id: @homework.id, user_id: 1, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    #@stuhomework_2 = Stuhomework.create! homework_id: @homework.id, user_id: @user_2.id, stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_2.txt')
    @stuhomework_1 = Fabricate(:stuhomework_1)
    @stuhomework_2 = Fabricate(:stuhomework_2)
  end

  test "student can create stuhomework" do
    log_in_as @user_1
    assert_difference 'Stuhomework.count', 1 do
      post :create, params: { homework_id: 1, stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') } }
    end
  end

  def reload_stuhomework(id)
    Stuhomework.find(id)
  end

  test "student edit their own stuhomework before check" do
    log_in_as @user_1
    # 可以成功修改自己的作业
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_e.txt')
    patch :update, params: { id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: stuhomeworkfile } }
    assert_redirected_to @stuhomework_1.homework
    @stuhomework_1 = reload_stuhomework(@stuhomework_1.id)
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_e.txt"

    # 如果在setup中创建一个stuhomework，在这里会引发callback
    @stuhomework_1.update_attributes(ischecked: true)
    #@stuhomework_1.update_columns(ischecked: true)
    patch :update, params: { id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_2.txt') } }
    @stuhomework_1 = reload_stuhomework(@stuhomework_1.id)
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_e.txt"
    assert_equal '已经批改过，无法进行修改', flash[:danger]
    assert_redirected_to @stuhomework_1.homework
  end

  test "can not edit others" do
    log_in_as @user_1
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    patch :update, params: { id: @stuhomework_2.id, stuhomework: { stuhomeworkfile: stuhomeworkfile } }
    assert_redirected_to root_url
  end

  test "admin can edit others" do
    log_in_as @user_a
    stuhomeworkfile = Rack::Test::UploadedFile.new('./test/file/test_e.txt')
    patch :update, params: { id: @stuhomework_1.id, stuhomework: { stuhomeworkfile: stuhomeworkfile } }
    assert_redirected_to @stuhomework_1.homework
    @stuhomework_1 = reload_stuhomework(@stuhomework_1.id)
    assert_equal @stuhomework_1[:stuhomeworkfile], "test_e.txt"
  end

  test "student can't check their homework" do
    log_in_as @user_1
    get :check, params: { id: @stuhomework_1.id }
    assert_redirected_to root_url
    assert_equal '权限不够，无法操作', flash[:warning]

    patch :check_complete, params: { id: @stuhomework_1.id, stuhomework: { mark: 100, remark: '不错' } }
    assert_redirected_to root_url
    assert_equal '权限不够，无法操作', flash[:warning]
  end

  #test "teacher can check stuhomework" do
  #stuhomework = stuhomeworks(:stuhomework_1)
  #log_in_as @user_t
  #patch :check_complete, id: stuhomework.id, stuhomework: { mark: 100, remark: '不错' }
  #stuhomework.reload
  #assert_redirected_to stuhomework.homework
  #assert_equal stuhomework.mark, 100
  #assert_equal stuhomework.remark, '不错'
  #end

  test "teacher can check stuhomework" do
    log_in_as @user_t
    patch :check_complete, params: { id: @stuhomework_1.id, stuhomework: { mark: 100, remark: '不错' } }
    @stuhomework_1.reload
    assert_redirected_to @stuhomework_1.homework
    assert_equal @stuhomework_1.mark, 100
    assert_equal @stuhomework_1.remark, '不错'
  end

end
