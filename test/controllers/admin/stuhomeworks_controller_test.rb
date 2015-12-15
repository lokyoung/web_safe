require 'test_helper'

class Admin::StuhomeworksControllerTest < ActionController::TestCase
  def setup
    log_in_as users(:admin1)
  end

  test "edit stuhomework" do
    stuhomework = Fabricate(:stuhomework)
    #binding.pry
    get :edit, id: stuhomework.id
    assert_response :success

    patch :update, id: stuhomework.id, stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_e.txt') }
    stuhomework.reload
    assert_equal 'test_e.txt', stuhomework[:stuhomeworkfile]
    assert_redirected_to admin_homework_stuhomeworks_url(homework_id: stuhomework.homework.id)
  end

end
