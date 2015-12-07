require 'test_helper'

class AnnounceTest < ActiveSupport::TestCase
  def setup
    @user = users(:example)
    @announce = @user.announces.build(title: "Title", content: "This is a annouce.")
  end

  test "normal valid" do
    assert @announce.valid?
  end

  test "title can't be blank" do
    @announce.title = ""
    assert_not @announce.valid?
  end

  test "content can't be blank" do
    @announce.content = ""
    assert_not @announce.valid?
  end

  test "order should be the last created" do
    assert_equal Announce.first, announces(:announce_b)
  end

end
