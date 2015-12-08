require 'test_helper'

class CoursewareTest < ActiveSupport::TestCase
  def setup
    @courseware = coursewares(:courseware_a)
  end

  test "valid" do
    binding.pry
    assert @courseware.valid?
  end

  test "title empty" do
    @courseware.title = ""
    assert_not @courseware.valid?
  end

  test "file empty" do
    @courseware.coursefile = ""
    assert_not @courseware.valid?
  end
end
