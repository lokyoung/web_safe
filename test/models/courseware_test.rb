require 'test_helper'

class CoursewareTest < ActiveSupport::TestCase
  def setup
    @courseware = Courseware.new title: "test", description: "ok", coursefile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "valid" do
    assert @courseware.valid?
  end

  test "title empty" do
    @courseware.title = ""
    assert_not @courseware.valid?
  end

  test "description empty" do
    @courseware.description = ""
    assert_not @courseware.valid?
  end

  test "file empty" do
    assert_not coursewares(:courseware_a).valid?
  end
end
