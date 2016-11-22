require 'test_helper'

class HomeworksControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @user4 = users(:teacher2)
    @homework = Homework.create user_id: @user2.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @homework_2 = Homework.create user_id: @user4.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Homework.count' do
      post :create, params: { homework: { title: 'hah', description: 'this is a des', homeworkfile: '123' } }
    end
    assert_redirected_to root_url
  end

  test "teacher can create and destroy but can't edit destroy others" do
    log_in_as(@user2)
    assert_difference 'Homework.count', 1 do
      post :create, params: { homework: { title: 'hah', description: 'this is a des', homeworkfile: Rack::Test::UploadedFile.new('./test/file/test_1.txt') } }
    end
    assert_redirected_to homeworks_url

    assert_difference 'Homework.count', -1 do
      delete :destroy, params: { id: 1 }
    end

    title = 'update title'
    description = 'update description'
    homeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #binding.pry
    patch :update, params: { id: @homework.id, homework: { title: title,
                                               description: description,
                                               homeworkfile: homeworkfile } }
    assert_redirected_to @homework
    @homework.reload
    #binding.pry
    assert_equal @homework.title, title
    assert_equal @homework.description, description
    assert_equal @homework[:homeworkfile], "test_1.txt"

    assert_no_difference 'Homework.count' do
      delete :destroy, params: { id: 2 }
    end

    patch :update, params: { id: @homework_2.id, homework: { title: title,
                                                 description: description,
                                                 homeworkfile: homeworkfile } }
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]
  end

  test "admin can create and destroy" do
    log_in_as(@user3)
    assert_difference 'Homework.count', 1 do
      post :create, params: { homework: { title: 'hah', description: 'this is a des', homeworkfile: Rack::Test::UploadedFile.new('./test/file/test_1.txt') } }
    end
    assert_redirected_to homeworks_url

    title = 'update title'
    description = 'update description'
    homeworkfile = fixture_file_upload('file/test_1.txt')
    patch :update, params: { id: @homework_2.id, homework: { title: title,
                                              description: description,
                                              homeworkfile: homeworkfile } }
    assert_redirected_to @homework_2
    @homework_2.reload
    assert_equal @homework_2.title, title
    assert_equal @homework_2.description, description
    assert_equal @homework_2[:homeworkfile], "test_1.txt"


    assert_difference 'Homework.count', -1 do
      delete :destroy, params: { id: 2 }
    end
  end

end
