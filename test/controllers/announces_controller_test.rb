require 'test_helper'

class AnnouncesControllerTest < ActionController::TestCase
  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    @user3 = users(:admin1)
    @announce = announces(:announce_2)
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
    assert_difference 'Announce.count', -1 do
      delete :destroy, id: 1
    end
    patch :update, id: @announce.id, announce: { title: 'ha', content: 'content!!!' }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
  end

  test "admin can create and destroy and update" do
    log_in_as(@user3)
    assert_difference 'Announce.count', 1 do
      post :create, announce: { title: 'hah', content: 'content!!!' }
    end
    assert_redirected_to root_url
    assert_difference 'Announce.count', -1 do
      delete :destroy, id: 1
    end
    patch :update, id: @announce.id, announce: { title: 'ha', content: 'content!!!' }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
  end
end
