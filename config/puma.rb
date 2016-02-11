#!/usr/bin/env puma

environment ENV['RAILS_ENV'] || 'production'

# daemonize true

pidfile "/var/www/web_safe/shared/tmp/pids/puma.pid"
stdout_redirect "/var/www/web_safe/shared/tmp/log/stdout", "/var/www/web_safe/shared/tmp/log/stderr"

threads 0, 16

bind "unix:///var/www/web_safe/shared/tmp/sockets/puma.sock"
