require 'test_helper'

class HomeworkTestTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:example)
    @homework = homeworks(:homework_1)
  end

  #test "homework list" do
    #log_in_as @user
    #get coursewares_path
    #assert_template 'coursewares/index'
    #assert_select 'title', '首页 | 花椒网安'
  #end

  #test "homework detail" do
    #log_in_as(@user)
    #get homework_path @homework
    #assert_response :success
    #assert_template 'homeworks/show'
    #assert_select "title", "#{@homework.title} | 花椒网安"
  #end
end
