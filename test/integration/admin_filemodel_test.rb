require 'test_helper'

class AdminFilemodelTest < ActionDispatch::IntegrationTest
  def setup
    #log_in_as Fabricate(:admin)
    log_in_as users(:admin1)
  end

  test "edit courseware" do
    #courseware = coursewares(:courseware_a)
    courseware = Fabricate(:courseware_1)
    #binding.pry
    get edit_admin_courseware_path(id: courseware.id)
    assert_select "div.panel-heading", text: "课件修改"
    assert_response :success

    coursefile = Rack::Test::UploadedFile.new('./test/file/test_2.txt')
    patch admin_courseware_path(id: courseware.id), courseware: { title: "update course",
                                                      description: "hah",
                                                      coursefile: coursefile }
    #courseware.reload
    #assert_equal 'update course', courseware.title
    #assert_equal courseware[:coursefile], 'test_2.txt'
    assert_redirected_to admin_coursewares_url
  end

  test "delete courseware" do
    courseware = Fabricate(:courseware_1)
    assert_difference 'Courseware.count', -1 do
      delete admin_courseware_path(courseware)
    end
  end

  test "edit homework" do
    homework = homeworks(:homework_1)
    #homework = Fabricate(:homework)
    get edit_admin_homework_path id: homework.id
    assert_select "div.panel-heading", text: "作业修改"
    assert_response :success

    patch admin_homework_path(id: homework.id), homework: { title: "update homework",
                                                  description: "hah",
                                                  homeworkfile: Rack::Test::UploadedFile.new('./test/file/test_2.txt') }
    homework.reload
    assert_equal 'update homework', homework.title
    assert_equal 'hah', homework.description
    assert_equal 'test_2.txt', homework[:homeworkfile]
    assert_redirected_to admin_homeworks_url
  end

  test "delete homework" do
    assert_difference 'Homework.count', -1 do
      delete admin_homework_path id: 1
    end
  end

  test "edit stuhomework" do
    stuhomework = Fabricate(:stuhomework)
    get edit_admin_stuhomework_path(id: stuhomework.id)
    assert_select "div.panel-heading", text: "学生作业修改"
    assert_response :success

    assert_equal 'test.txt', stuhomework[:stuhomeworkfile]
    patch admin_stuhomework_path(id: stuhomework.id), stuhomework: { stuhomeworkfile: Rack::Test::UploadedFile.new('./test/file/test_e.txt') }
    stuhomework.reload
    assert_equal 'test_e.txt', stuhomework[:stuhomeworkfile]
    assert_redirected_to admin_homework_stuhomeworks_url(homework_id: stuhomework.homework.id)

    patch admin_stuhomework_path(id: stuhomework.id), stuhomework: { ischecked: true, mark: 100, remark: 'great' }
    stuhomework.reload
    assert_equal stuhomework.ischecked, true
    assert_redirected_to admin_homework_stuhomeworks_url(homework_id: stuhomework.homework.id)
  end

  test "delete stuhomework" do
    assert_difference 'Stuhomework.count', -1 do
      delete admin_stuhomework_path id: 1
    end
  end
end
