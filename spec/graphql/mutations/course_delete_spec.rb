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
      let(:course) do
        course = FactoryBot.create(:course, :with_chapters_and_units)
        course = Course.joins(chapters: :units).find(course.id)
      end
      let(:variables) do
        {
          "input": {
            "id": course.id,
          },
        }
      end

      it "delete a course" do
        course_id = course.id
        chapter_ids = course.chapters.map(&:id)
        unit_ids = Unit.where(chapter_id: chapter_ids).pluck(:id)

        post "/graphql", params: { query: mutation, variables: variables }
        body = JSON.parse(response.body)
        puts "body: #{body.inspect}"
        data = body["data"]["courseDelete"]["course"]

        expect(data).to include(
                          "id" => course.id.to_s,
                        )

        course_id = course.id
        chapter_ids = course.chapters.map(&:id)
        unit_ids = Unit.where(chapter_id: chapter_ids).pluck(:id)

        # Verify they're not found in the database
        expect(Course.find_by(id: course_id)).to be_nil
        expect(Chapter.find_by(id: chapter_ids)).to be_nil
        expect(Unit.find_by(id: unit_ids)).to be_nil
      end
    end
  end
end
