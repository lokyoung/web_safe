## 花椒网安实验室

这是花椒网安实验室项目的源码。  
This is the source code of my web_safe site.

## Requirements
* Ruby 2.2.0 +
* Rails 4.2.5 +
* Redis 2.2 +
* Postgresql, Mysql or sqlite3
* ImageMagick 6.5+

## Install in development

### Mac OS X

Use Homebrew
```sh
$ brew install redis
$ brew install postgresql
$ brew install imagemagic
```

### Ubuntu
```sh
$ apt-get install redis
$ apt-get install postgresql
$ apt-get install imagemagic
```

## 运行项目
```sh
$ git clone git@github.com:lokyoung/web_safe.git
$ cd web_safe
$ bundle install
$ ./bin/rake db:migrate
$ ./bin/rails server
```

## 运行测试
```sh
$ rake test
```

## Sites
* [花椒网安](http://hj-websafe.com)
