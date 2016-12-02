require 'test_helper'

class Admin::AnnouncesControllerTest < ActionController::TestCase

  def setup
    @user_a = users(:admin1)
  end

  test "admin announce index" do
    log_in_as @user_a
    get :index
    assert_response :success
    Announce.page(1).each do |announce|
      assert_select 'a[href=?]', admin_announce_path(announce)
      assert_select 'a[href=?]', edit_admin_announce_path(announce)
    end
    assert_select "table" do
      assert_select "tr", 16
    end
    assert_select "span.next"

    get :index, params: { page: 4 }
    assert_response :success
    assert_select "span.prev"
  end

end
