require 'test_helper'

class CoursewaresControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @courseware = Courseware.create user_id: @user2.id, title: "test", description: "ok", coursefile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    @courseware_1 = Courseware.create user_id: @user3.id, title: "test", description: "ok", coursefile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Courseware.count' do
      post :create, courseware: { title: 'hah', description: 'this is a des', coursefile: Rack::Test::UploadedFile.new('./test/file/test.txt') }
    end
    assert_redirected_to root_url
  end

  test "teacher can create destroy and update" do
    log_in_as(@user2)
    assert_difference 'Courseware.count', 1 do
      post :create, courseware: { title: 'hah', description: 'this is a des', coursefile: fixture_file_upload('file/test.txt') }
    end
    assert_redirected_to coursewares_url
    title = 'update title'
    description = 'update description'
    coursefile = fixture_file_upload('file/test_1.txt')
    #binding.pry
    patch :update, id: @courseware.id, courseware: { title: title,
                                                     description: description,
                                                     coursefile: coursefile }
    assert_redirected_to coursewares_url
    @courseware.reload
    assert_equal @courseware.title, title
    assert_equal @courseware.description, description
    assert_equal @courseware[:coursefile], "test_1.txt"
    assert_difference 'Courseware.count', -1 do
      delete :destroy, id: @courseware.id
    end
  end

  test "admin can create and destroy" do
    log_in_as(@user3)
    assert_difference 'Courseware.count', 1 do
      post :create, courseware: { title: 'hah', description: 'this is a des', coursefile: fixture_file_upload('file/test.txt') }
    end
    assert_redirected_to coursewares_url
    assert_difference 'Courseware.count', -1 do
      delete :destroy, id: @courseware.id
    end
  end

  test "create fail" do
    log_in_as(@user3)
    assert_no_difference 'Courseware.count' do
      post :create, courseware: { title: '', description: "test", coursefile: "123" }
    end
    assert_template 'coursewares/new'
    assert_no_difference 'Courseware.count' do
      post :create, courseware: { title: '123', description: "", coursefile: "123" }
    end
    assert_template 'coursewares/new'
  end

  test "can't edit other courseware" do
    log_in_as(@user2)
    title = 'update title'
    description = 'update description'
    coursefile = fixture_file_upload('file/test_1.txt')
    #binding.pry
    patch :update, id: @courseware_1.id, courseware: { title: title,
                                                     description: description,
                                                     coursefile: coursefile }
    assert_redirected_to root_url
  end

  test "admin can edit other courseware" do
    log_in_as(@user3)
    title = 'update title'
    description = 'update description'
    coursefile = fixture_file_upload('file/test_1.txt')
    #binding.pry
    patch :update, id: @courseware.id, courseware: { title: title,
                                                     description: description,
                                                     coursefile: coursefile }
    assert_redirected_to coursewares_url
    @courseware.reload
    assert_equal @courseware.title, title
    assert_equal @courseware.description, description
    assert_equal @courseware[:coursefile], "test_1.txt"
  end

end
