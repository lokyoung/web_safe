ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # 测试中引入helper方法
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...

  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options={})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, params: {session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me } }
    else
      session[:user_id] = user.id
    end
  end

  def full_title(page_title = '')
    base_title = '花椒网安'
    if(page_title.empty?)
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  private

  def integration_test?
    defined?(post_via_redirect)
  end
end
