# README

[![Ruby on Rails CI](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml/badge.svg?branch=main)](https://github.com/unknowntpo/courses_manager/actions/workflows/rubyonrails.yml)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Quick Start

### Database / Cache initialization

Use docker-compose to set up PostgreSQL and Redis.

```
$ docker-compose up -d
```

### Database creation and schema migration

```
$ rails db:setup
$ rails db:migrate
```

### Add fake data for local development

```
$ rails db:seed
```

* How to run the test suite

```
$ rails spec
```

## System dependencies

### Ruby version:

- `3.2.2`

### Gems
* FactoryBot:

I use it to create fake data for testing and local development, we can use

```
$ rails db:seeds to inject some fake data into database.
```


### Documentation

Generate latest documentation:

```
$ yard
```

run local YARD documentation server.

```
$ yard server
```

## API Specification

- https://github.com/unknowntpo/courses_manager/issues/6


## Demo App

GraphQL API Endpoint: https://hahow-courses-manager-2b2aea0eb45b.herokuapp.com/graphql

## Unfinished:

- Use Dataloader to avoid (N + 1) problem.
- Use cache to avoid querying DB too often.
- Use [Optimistic Locking](https://api.rubyonrails.org/classes/ActiveRecord/Locking/Optimistic.html) to avoid race condition.