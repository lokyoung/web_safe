require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # setup会在每个测试方法运行前执行
  def setup
    @user = User.new(name: "One User", email: "test@usertest.com", password: "123456", password_confirmation: "123456")
  end

  test "simple test" do
    assert @user.valid?
  end

  test "name can't be blank" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "name can't be too long" do
    @user.name = "a" * 21
    assert_not @user.valid?
  end

  test "email can't be blank" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "email maximun" do
    @user.email = "a" * 93 + "@qq.com"
    assert @user.valid?
  end

  test "email can't be too long" do
    @user.email = "a" * 94 + "@qq.com"
    assert_not @user.valid?
  end

  test "email address should be valid" do
    valid_addresses = %w[myaddress@my.com MYE@EXAMPLE.COM 12+12ab@qqK.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} is not valid"
    end
  end

  test "email address should be invalid" do
    invalid_addresses = %w[myaddress@my/com MYE.EXAMPLE.COM 12+12ab@qq_K.com 
                           abcd@qq+K.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} is valid"
    end
  end

  test "email address should be unique" do
    dup_user = @user.dup
    @user.save
    assert_not dup_user.valid?
  end

  test "password minimum length sholde be 6" do
    @user.password = @user.password_confirmation = "a" * 6
    assert @user.valid?
  end

  test "password minimum can't be shorter than 6 " do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "password and password_confirm should be the same" do
    @user.password = "123456"
    @user.password_confirmation = "12345678"
    assert_not @user.valid?
  end

  # 用户删除之后对应的公告也被删除
  test "user delete so does his annouces" do
    @user.save
    @user.announces.create!(title: "Title", content: "Haha")
    assert_difference "Announce.count", -1 do
      @user.destroy
    end
  end

end
