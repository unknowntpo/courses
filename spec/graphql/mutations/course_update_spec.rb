require "rails_helper"

module Mutations
  RSpec.describe Mutations::CourseUpdate, type: :request do
    context ".resolve" do
      let(:mutation) do
        <<-GQL
      mutation courseUpdate($input: CourseUpdateInput!) {
        courseUpdate(input: $input) {
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
      let(:variables) do
        {
          "input": {
            "id": course.id,
            "input": {
              "name": "C",
              "description": "Oh my god",
            },
          },
        }
      end

      it "updates a course" do
        post "/graphql", params: { query: mutation, variables: variables }
        body = JSON.parse(response.body)
        puts "body: #{body.inspect}"
        data = body["data"]["courseUpdate"]["course"]

        puts "course:#{course}"

        expect(data).to include(
                          "id" => course.id.to_s,
                          "name" => variables[:input][:input][:name],
                          "lecturer" => course.lecturer,
                          "description" => variables[:input][:input][:description],
                        )
      end
    end
  end
end
