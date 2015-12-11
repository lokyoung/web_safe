require 'test_helper'

class HomeworkOptionsTest < ActionDispatch::IntegrationTest
  def setup
    @user1 = users(:user_1)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @homework = Homework.create user_id: @user2.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @homework_1 = Homework.create user_id: @user3.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  def teardown
    @homework.destroy
    @homework_1.destroy
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Homework.count' do
      post homeworks_path, homework: { title: 'hah', description: 'this is a des', homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to root_url
  end

  test "teacher can create destroy and update" do
    log_in_as(@user2)
    assert_difference 'Homework.count', 1 do
      post homeworks_path, homework: { title: 'hah', description: 'this is a des', homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to homeworks_url
    title = 'update title'
    description = 'update description'
    homeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #binding.pry
    patch homework_path @homework, homework: { title: title,
                                               description: description,
                                               homeworkfile: homeworkfile }
    assert_redirected_to @homework
    @homework.reload
    #binding.pry
    assert_equal @homework.title, title
    assert_equal @homework.description, description
    #assert_equal @homework[:homeworkfile], "test_1.txt"
    assert_difference 'Homework.count', -1 do
      delete homework_path @homework
    end
  end

  test "admin can create and destroy" do
    log_in_as(@user3)
    assert_difference 'Homework.count', 1 do
      post homeworks_path, homework: { title: 'hah', description: 'this is a des', homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to homeworks_url
    assert_difference 'Homework.count', -1 do
      delete homework_path @homework
    end
  end

  test "create fail" do
    log_in_as(@user3)
    assert_no_difference 'Homework.count' do
      post homeworks_path, homework: { title: '', description: "test", homeworkfile: "123" }
    end
    assert_template 'homeworks/new'
    assert_no_difference 'Homework.count' do
      post homeworks_path, homework: { title: '123', description: "", homeworkfile: "123" }
    end
    assert_template 'homeworks/new'
  end

  test "can't edit delete other homework" do
    log_in_as(@user2)
    title = 'update title'
    description = 'update description'
    homeworkfile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #binding.pry
    patch homework_path @homework_1, homework: { title: title,
                                                 description: description,
                                                 homeworkfile: homeworkfile }
    assert_redirected_to root_url
    assert_no_difference 'Homework.count' do
      delete homework_path @homework_1
    end
    assert_redirected_to root_url
  end

  test "admin can edit other homework" do
    log_in_as(@user3)
    title = 'update title'
    description = 'update description'
    homeworkfile = fixture_file_upload('./test/file/test_1.txt')
    #binding.pry
    homework = Homework.create user_id: @user3.id, title: "test", description: "ok", homeworkfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    patch homework_path homework, homework: { title: title,
                                              description: description,
                                              homeworkfile: homeworkfile }
    assert_redirected_to homework
    homework.reload
    assert_equal homework.title, title
    assert_equal homework.description, description
    #assert_equal homework[:homeworkfile], "test_1.txt"
  end
end
