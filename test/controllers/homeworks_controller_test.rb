require 'test_helper'

class HomeworksControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @homework = Homework.create user_id: @user2.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @homework_1 = Homework.create user_id: @user3.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Homework.count' do
      post :create, homework: { title: 'hah', description: 'this is a des', homeworkfile: '123' }
    end
    assert_redirected_to root_url
  end

  test "teacher can create and destroy" do
    log_in_as(@user2)
    assert_difference 'Homework.count', 1 do
      post :create, homework: { title: 'hah', description: 'this is a des', homeworkfile: '123' }
    end
    assert_redirected_to homeworks_url
    assert_difference 'Homework.count', -1 do
      delete :destroy, id: 1
    end
    title = 'update title'
    description = 'update description'
    homeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #binding.pry
    patch :update, id: @homework.id, homework: { title: title,
                                               description: description,
                                               homeworkfile: homeworkfile }
    assert_redirected_to homeworks_url
    @homework.reload
    #binding.pry
    assert_equal @homework.title, title
    assert_equal @homework.description, description
    assert_equal @homework[:homeworkfile], "test_1.txt"
  end

  test "admin can create and destroy" do
    log_in_as(@user3)
    assert_difference 'Homework.count', 1 do
      post :create, homework: { title: 'hah', description: 'this is a des', homeworkfile: '123' }
    end
    assert_redirected_to homeworks_url
    assert_difference 'Homework.count', -1 do
      delete :destroy, id: 1
    end
  end

end
