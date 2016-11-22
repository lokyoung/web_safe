require "test_helper"

class ExperimentsControllerTest < ActionController::TestCase
  #def test_sanity
  #flunk "Need real tests"
  #end
  def setup
    @user1 = Fabricate(:student)
    @user_t = Fabricate(:teacher)
    @user_a = Fabricate(:admin)
    #@experiment = Experiment.create user_id: @user2.id, title: "test", description: "ok", experimentfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
    #@experiment_1 = Experiment.create user_id: @user3.id, title: "test", description: "ok", experimentfile: Rack::Test::UploadedFile.new('./test/file/test.txt')
  end

  test "student can not create experiment" do
    log_in_as(@user1)
    assert_no_difference 'Experiment.count' do
      post :create, params: { experiment: { title: "title", description: "des", experimentfile: Rack::Test::UploadedFile.new('./test/file/test.txt') } }
    end
    assert_redirected_to root_url
  end

  test "teacher can create the experiment" do
    log_in_as(@user_t)
    assert_difference 'Experiment.count', 1 do
      post :create, params: { experiment: { title: "title", description: "des", experimentfile: Rack::Test::UploadedFile.new('./test/file/test.txt') } }
    end
    assert_redirected_to experiments_url
  end
end
