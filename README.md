# README

[![Ruby on Rails CI](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml/badge.svg?branch=main)](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

swagger:

Use this comand to generate rswag integration test

```
$ rails g rspec:swagger API::V1::CoursesController --spec_path integration

Generate swagger yaml file

```
$ rake rswag
```

Ref: [Rswag Github](https://github.com/rswag/rswag#getting-started)

* ...
