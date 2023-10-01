require "rails_helper"

module Mutations
  RSpec.describe Mutations::CourseUpdate, type: :request do
    context "update course" do
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
        post "/graphql", params: { query: mutation, variables: variables.to_json }
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

    context "reorder chapters in a course" do
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
      let(:chapters) do
        chapters = Chapter.where(:course_id => course.id)
        chapters.each_with_index.map do |chapter, i|
          # chapter.attributes.slice("id", "name", "position")
          {
            "id": chapter.id,
            "courseId": chapter.course_id.to_i,
            "position": chapters.length - 1 - i # Ensure integer value
          }
        end
      end
      let(:variables) do
        {
          "input": {
            "id": course.id,
            "input": {
              "name": "C",
              "description": "Oh my god",
              "chapters": chapters,
            },
          },
        }
      end

      it "should be reordered" do
        puts "variables: #{JSON.pretty_generate(variables)}"
        post "/graphql", params: { query: mutation, variables: variables.to_json }

        body = JSON.parse(response.body)
        puts " body : #{body.inspect}"
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
