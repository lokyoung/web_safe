## 花椒网安实验室

这是花椒网安实验室项目的源码。  
This is the source code of my web_safe site.

## Requirements
* Ruby 2.2.0 +
* Rails 4.2.5 +
* Redis 2.2 +
* Postgresql, Mysql or sqlite3

## Install in development

### Mac OS X

Use Homebrew
```sh
$ brew install redis
$ brew install postgresql
$ brew install imagemagic
```

## 运行项目
```sh
$ bundle install
$ rake db:migrate
$ rails server
$ bin/cable
```

## 运行测试
```sh
$ rake test
```
