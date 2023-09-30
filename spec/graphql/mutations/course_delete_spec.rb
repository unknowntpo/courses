require "rails_helper"

module Mutations
  RSpec.describe Mutations::CourseDelete, type: :request do
    context ".resolve" do
      let(:mutation) do
        <<-GQL
      mutation courseDelete($input: CourseDeleteInput!) {
        courseDelete(input: $input) {
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
          },
        }
      end

      it "delete a course" do
        post "/graphql", params: { query: mutation, variables: variables }
        body = JSON.parse(response.body)
        puts "body: #{body.inspect}"
        data = body["data"]["courseDelete"]["course"]

        puts "course:#{course}"

        expect(data).to include(
                          "id" => course.id.to_s,
                        )
      end
    end
  end
end
