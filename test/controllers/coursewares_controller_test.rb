require 'test_helper'

class CoursewaresControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Courseware.count' do
      post :create, courseware: { title: 'hah', description: 'this is a des', coursefile: '123' }
    end
    assert_redirected_to root_url
  end

  #test "teacher can create and destroy" do
    #log_in_as(@user2)
    #assert_difference 'Courseware.count', 1 do
      #post :create, courseware: { title: 'hah', description: 'this is a des' }
    #end
    #assert_redirected_to coursewares_url
    #assert_difference 'Courseware.count', -1 do
      #delete :destroy, id: 1
    #end
  #end

  #test "admin can create and destroy" do
    #log_in_as(@user3)
    #assert_difference 'Courseware.count', 1 do
      #post :create, courseware: { title: 'hah', description: 'this is a des', coursefile: '123' }
    #end
    #assert_redirected_to coursewares_url
    #assert_difference 'Courseware.count', -1 do
      #delete :destroy, id: 1
    #end
  #end

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

end
