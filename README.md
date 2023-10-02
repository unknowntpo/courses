# README

[![Ruby on Rails CI](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml/badge.svg?branch=main)](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: `3.2.2`

* System dependencies

gem I used

* FactoryBot
* 


* Database creation

```
$ rails db:setup
$ rails db:migrate
$ rails db:seed
```

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Documentation

Use `yard` to generate latest documentation.

Then use `yard server` to run local yard server.


## Graphql

Get all courses

```
query {
  courses {
    edges {
      cursor
      node {
        name
        lecturer
        description  
      }
    }
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
  }
}
```

Unfinished:

- Use Dataloader to avoid (N + 1) problem.
- Use cache to avoid querying DB too often.