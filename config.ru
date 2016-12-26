# This file is used by Rack-based servers to start the application.

#require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
# Require your environment file to bootstrap Rails
require ::File.dirname(__FILE__) + '/config/environment'

# Serve static assets from RAILS_ROOT/public directory
# # use Rails::Rack::Static
# # Dispatch the request
#run ActionController::Dispatcher.new
