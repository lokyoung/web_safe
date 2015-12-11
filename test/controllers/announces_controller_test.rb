require 'test_helper'

class AnnouncesControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @announce = announces(:announce_1)
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Announce.count' do
      post :create, announce: { title: 'hah', content: 'content!!!' }
    end
    assert_redirected_to root_url
  end

  test "teacher can create and destroy and update" do
    log_in_as(@user2)
    assert_difference 'Announce.count', 1 do
      post :create, announce: { title: 'hah', content: 'content!!!' }
    end
    assert_redirected_to root_url
    patch :update, id: @announce.id, announce: { title: 'ha', content: 'content!!!' }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
    assert_difference 'Announce.count', -1 do
      delete :destroy, id: 1
    end
  end

  test "can't edit and destroy others" do
    log_in_as @user2
    assert_no_difference 'Announce.count' do
      delete :destroy, id: 2
    end
    assert_redirected_to root_url
    patch :update, id: 2, announce: { title: 'ha', content: 'content!!!' }
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]
  end

  test "admin can create and destroy and update" do
    log_in_as(@user3)
    assert_difference 'Announce.count', 1 do
      post :create, announce: { title: 'hah', content: 'content!!!' }
    end
    assert_redirected_to root_url
    patch :update, id: @announce.id, announce: { title: 'ha', content: 'content!!!' }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
    assert_difference 'Announce.count', -1 do
      delete :destroy, id: 1
    end
  end
end
