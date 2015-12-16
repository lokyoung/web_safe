require 'test_helper'

class StuclassesControllerTest < ActionController::TestCase
  def setup
    @user_1 ||= Fabricate(:student)
    @user_2 ||= Fabricate(:teacher)
    @stuclass ||= @user_1.stuclass
  end

  test "student can't create the stuclass" do
    log_in_as @user_1
    assert_no_difference 'Stuclass.count' do
      post :create, stuclass: { scname: 'class 1' }
    end
    assert_redirected_to root_url
  end

  test "teacher can create the stuclass" do
    log_in_as @user_2
    assert_difference 'Stuclass.count', 1 do
      post :create, stuclass: { scname: 'class 1' }
    end
    assert_redirected_to stuclasses_url
  end

  test "teacher can edit the stuclass" do
    log_in_as @user_2
    get :edit, id: 1
    assert_response :success
    patch :update, id: 1, stuclass: { scname: 'stuclass 1' }
    @stuclass.reload
    assert_redirected_to @stuclass
    assert_equal @stuclass.scname, 'stuclass 1'
  end

  test "teacher can destroy the stuclass" do
    log_in_as @user_2
    assert_difference 'Stuclass.count', -1 do
      delete :destroy, id: 1
    end
    assert_redirected_to stuclasses_url
  end
end
