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
          errors
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
        errors = body["data"]["courseCreate"]["errors"]
        data = body["data"]["courseCreate"]["course"]

        wantErrors = {
          "lecturer": "Lecturer can't be blank",
          "chapters": [
            {
              "units": [
                {
                  "name": "Name can't be blank",
                },
              ],
            },
          ],
        }
        expect(data).to be_nil
        expect(errors).to eq(wantErrors)
      end
    end
  end
end
