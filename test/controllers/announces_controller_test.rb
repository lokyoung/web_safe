require 'test_helper'

class AnnouncesControllerTest < ActionController::TestCase
  def setup
    @user1 = Fabricate(:student)
    @user2 = Fabricate(:teacher)
    @user3 = Fabricate(:admin)
    #@announce = announces(:announce_1)
    @announce = Fabricate(:announce_1)
  end

  test "can not create unless teacher" do
    log_in_as(@user1)
    assert_no_difference 'Announce.count' do
      post :create, params: { announce: { title: 'hah', content: 'content!!!' } }
    end
    assert_redirected_to root_url
  end

  test "teacher can edit their own announce" do
    log_in_as @user2
    get :edit, params: { id: @announce.id }
    assert_response :success
  end

  test "teacher can create and destroy and update" do
    log_in_as(@user2)
    assert_difference 'Announce.count', 1 do
      post :create, params: { announce: { title: 'hah', content: 'content!!!' } }
    end
    assert_redirected_to root_url
    patch :update, params: { id: @announce.id, announce: { title: 'ha', content: 'content!!!' } }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
    assert_difference 'Announce.count', -1 do
      delete :destroy, params: { id: @announce.id }
    end
  end

  test "can't edit and destroy others" do
    log_in_as @user2
    assert_no_difference 'Announce.count' do
      delete :destroy, params: { id: 2 }
    end
    assert_redirected_to root_url
    patch :update, params: { id: 2, announce: { title: 'ha', content: 'content!!!' } }
    assert_redirected_to root_url
    assert_equal '请不要尝试修改他人的内容', flash[:warning]
  end

  test "admin can create and destroy and update" do
    log_in_as(@user3)
    assert_difference 'Announce.count', 1 do
      post :create, params: { announce: { title: 'hah', content: 'content!!!' } }
    end
    assert_redirected_to root_url
    patch :update, params: { id: @announce.id, announce: { title: 'ha', content: 'content!!!' } }
    @announce.reload
    assert_equal @announce.title, 'ha'
    assert_redirected_to @announce
    assert_difference 'Announce.count', -1 do
      delete :destroy, params: { id: 1 }
    end
  end
end
