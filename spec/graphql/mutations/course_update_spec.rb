require "rails_helper"

module Mutations
  RSpec.describe Mutations::CourseUpdate, type: :request do
    context "update course" do
      let(:mutation) do
        <<-GQL
      mutation courseUpdate($input: CourseUpdateInput!) {
        courseUpdate(input: $input) {
          error
          course {
            id
            name
            lecturer
            description
          }
        }
      }
        GQL
      end
      let(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      context "succeed" do
        let(:variables) do
          {
            "input": {
              "id": course.id,
              "input": {
                "name": "C",
                "lecturer": "new lecturer",
                "description": "Oh my god",
              },
            },
          }
        end

        it "updates a course" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{body.inspect}"
          data = body["data"]["courseUpdate"]["course"]

          puts "course:#{course}"

          updated_course = Course.find(course.id)
          expect(updated_course.name).to eq(variables[:input][:input][:name])
          expect(updated_course.lecturer).to eq(variables[:input][:input][:lecturer])
          expect(updated_course.description).to eq(variables[:input][:input][:description])

          expect(data).to include(
            "id" => course.id.to_s,
            "name" => variables[:input][:input][:name],
            "lecturer" => variables[:input][:input][:lecturer],
            "description" => variables[:input][:input][:description],
          )
        end
      end
      context "failed" do
        let(:variables) do
          {
            "input": {
              "id": course.id,
              "input": {
                "name": "",
                "lecturer": "",
                "description": "Oh my god",
              },
            },
          }
        end

        it "invalid field should be annotated" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          data = body["data"]["courseUpdate"]["course"]
          error = body["data"]["courseUpdate"]["error"]

          expect(data).to be_nil
          expect(error["course"]).to include(
            "name" => ["can't be blank"],
            "lecturer" => ["can't be blank"],
          )
        end
      end
    end
  end
end
