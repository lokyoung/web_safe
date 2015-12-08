require 'test_helper'

class CoursewareTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:example)
    @courseware = coursewares(:courseware_a)
  end

  test "can't see unless log_in" do
    get coursewares_path
    assert_response :redirect
  end

  #test "courseware list" do
    #log_in_as @user
    #get coursewares_path
    #assert_response :success
    #assert_template 'coursewares/index'
    #assert_select 'title', '课件 | 花椒网安'
  #end

  #test "courseware detail" do
    #log_in_as(@user)
    #get courseware_path @courseware
    #assert_response :success
    #assert_select "title", "#{@courseware.title} | 花椒网安"
  #end

end
