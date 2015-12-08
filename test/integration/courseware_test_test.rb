require 'test_helper'

class CoursewareTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user1 = users(:example)
    @user2 = users(:teacher1)
    #@courseware = Courseware.create user_id: @user2.id, title: "test", description: "ok", coursefile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "can't see unless log_in" do
    get coursewares_path
    assert_response :redirect
  end

  #test "edit courseware" do
    #log_in_as @user2
    #get edit_courseware_path(@courseware)
    #assert_response :success
    #title = 'update title'
    #description = 'update description'
    #coursefile = Rack::Test::UploadedFile.new('./test/file/test_1.txt')
    #patch courseware_path(@courseware), courseware: { title: title,
                                                      #description: description,
                                                      #coursefile: coursefile }
  #end

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
