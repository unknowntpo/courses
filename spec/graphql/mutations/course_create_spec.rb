require "rails_helper"

module Mutations
  RSpec.describe Mutations::CourseCreate, type: :request do
    let(:mutation) do
      <<-GQL
      mutation courseCreate($input: CourseCreateInput!) {
        courseCreate(input: $input) {
          course {
            id
            name
            lecturer
            description
            chapters {
              name
              position
              units {
                name
                description
                content
                position
              }
            }
          }
          error
        }
      }
        GQL
    end
    context "create" do
      context "succeed" do
        let(:variables) do
          {
            "input": {
              "input": {
                "name": "Go",
                "lecturer": "Rob Pike",
                "description": "hardcore!",
                "chapters": [
                  {
                    "name": "Setup",
                    "units": [
                      {
                        "name": "Run go build",
                        "description": "easy",
                        "content": "go build",
                      },
                    ],
                  },
                  {
                    "name": "Learn the basics",
                    "units": [
                      {
                        "name": "Primary Type",
                        "description": "easy",
                        "content": "int, string,...",
                      },
                    ],
                  },
                ],
              },
            },
          }
        end

        it "creates a course" do
          post "/graphql", params: { query: mutation, variables: variables }
          body = JSON.parse(response.body)
          puts "body: #{body.inspect}"
          data = body["data"]["courseCreate"]["course"]

          new_course = ::Course.last

          puts "newCourse:#{new_course}"

          all_courses = ::Course.all
          puts "all_courses: #{all_courses.inspect}"

          expect(data).to include(
            "id" => new_course.id.to_s,
            "name" => new_course.name,
            "lecturer" => new_course.lecturer,
            "description" => new_course.description,
            "chapters" => a_collection_containing_exactly(
              *new_course.chapters.map do |chapter|
              hash_including(
                "name" => chapter[:name],
                "position" => chapter[:position],
                "units" => a_collection_containing_exactly(
                  *chapter.units.map do |unit|
                  hash_including(
                    "name" => unit[:name],
                    "description" => unit[:description],
                    "content" => unit[:content],
                    "position" => unit[:position],
                  )
                end
                ),
              )
            end
            ),
          )
        end
      end
    end
    context "failed" do
      let(:variables) do
        {
          "input": {
            "input": {
              "name": "Go",
              # "lecturer": "Rob Pike",
              "description": "hardcore!",
              "chapters": [
                {
                  "name": "Setup",
                  "units": [
                    {
                      # "name": "Run go build",
                      "description": "easy",
                      "content": "go build",
                    },
                  ],
                },
                {
                  "name": "Learn the basics",
                  "units": [
                    {
                      "name": "Primary Type",
                      "description": "easy",
                    # "content": "int, string,...",
                    },
                  ],
                },
              ],
            },
          },
        }
      end
      it "creates a course" do
        post "/graphql", params: { query: mutation, variables: variables }
        body = JSON.parse(response.body)
        puts "body: #{JSON.pretty_generate(body)}"
        error = body["data"]["courseCreate"]["error"].deep_symbolize_keys
        data = body["data"]["courseCreate"]["course"]

        # TODO: tweak the error message based on the spec
        wantError = {
          "lecturer": ["can't be blank"],
          "chapters": [
            {
              "units": [
                {
                  "_index": 0,
                  "name": ["can't be blank"],
                },
              ],
              "_index": 0,
            },
            {
              "units": [
                {
                  "_index": 0,
                  "content": ["can't be blank"],
                },
              ],
              "_index": 1,
            },
          ],
        }
        expect(data).to be_nil
        # puts "error: #{JSON.pretty_generate(error)}"
        # puts "wantErrror: #{JSON.pretty_generate(wantError)}"
        expect(error).to eq(wantError)
      end
    end
  end
end
