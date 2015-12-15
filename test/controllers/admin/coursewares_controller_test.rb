require 'test_helper'

class Admin::CoursewaresControllerTest < ActionController::TestCase
  def setup
    log_in_as Fabricate(:admin)
    @courseware = Fabricate(:courseware_1)
  end

  test "edit" do
    #get edit_admin_courseware_path(courseware)
    get :edit, id: @courseware.id
    assert_select "div.panel-heading", text: "课件修改"
    assert_response :success
  end

  test "delete" do
    assert_difference 'Courseware.count', -1 do
      delete :destroy, id: @courseware.id
    end
  end
end
