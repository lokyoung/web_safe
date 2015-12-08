require 'test_helper'

class HomeworksControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
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
