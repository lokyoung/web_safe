require 'test_helper'

class AnnouncesControllerTest < ActionController::TestCase
  def setup
  end

  test "can not create before login" do
    assert_no_difference 'Announce.count' do
      post :create, announce: { title: 'hah', content: 'content!!!' }
    end
    assert_redirected_to login_url
  end
end
