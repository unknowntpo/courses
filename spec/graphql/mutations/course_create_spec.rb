require 'rails_helper'

module Mutations
  RSpec.describe Mutations::CourseCreate, type: :request do
    context '.resolve' do
      let(:mutation) do
        <<-GQL
      mutation courseCreate($input: CourseCreateInput!) {
        courseCreate(input: $input) {
          course {
            name
            lecturer
            description
          }
        }
      }
        GQL
      end
      let(:variables) do
        {
          "input": {
            "input": {
              "name": "Go",
              "lecturer": "Rob Pike",
              "description": "hardcore!",
              "chapters": [
                { "name": "Setup" },
                { "name": "Go build" }
              ]
            }
          }
        }
      end

      it 'creates a course' do
        post '/graphql', params: { query: mutation, variables: variables }
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
  end
end
