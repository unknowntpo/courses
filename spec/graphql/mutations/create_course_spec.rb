require 'rails_helper'

module Mutations
  RSpec.describe Mutations::CreateCourse, type: :request do
    describe '.resolve' do
      it 'creates a course' do
        first_name = 'John'
        last_name = 'Doe'
        email = 'johndoe@example.com'

        chapters = [
          { title: 'Chapter1', year: 2022, genre: 'Action' },
          { title: 'Chapter2', year: 2021, genre: 'Drama' }
        ]

        post '/graphql', params: { query: _query(first_name, last_name, email, chapters) }
        body = JSON.parse(response.body)
        puts "body: #{body.inspect}"
        data = body['data']['createCourse']['course']

        new_course = ::Course.last

        expect(data).to include(
          'id' => new_course.id.to_s,
          'firstName' => new_course.first_name,
          'lastName' => new_course.last_name,
          'email' => new_course.email,
          'chapters' => a_collection_containing_exactly(
            *chapters.map do |chapter|
              hash_including('title' => chapter[:title], 'year' => chapter[:year], 'genre' => chapter[:genre])
            end
          )
        )
      end
    end

    def _query(first_name, last_name, email, chapters)
      chapters_input = chapters.map do |chapter|
        "{ title: \"#{chapter[:title]}\", year: #{chapter[:year]}, genre: \"#{chapter[:genre]}\" }"
      end.join(', ')

      puts "chapters_input: #{chapters_input.inspect}"

      <<~GQL
        mutation {
          createCourse(input: {
            firstName: "#{first_name}",
            lastName: "#{last_name}",
            email: "#{email}",
            chapters: [#{chapters_input}]
          }) {
            course {
              id
              name
              description
              chapters {
                name
                description
              }
            }
          }
        }
      GQL
    end
  end
end
