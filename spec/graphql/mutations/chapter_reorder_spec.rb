require "rails_helper"

module Mutations
  RSpec.describe Mutations::ChapterReorder, type: :request do
    context "reorder chapter" do
      let(:mutation) do
        <<-GQL
        mutation chapterReorder($input: ChapterReorderInput!) {
          chapterReorder(input: $input) {
            error
            course {
              name
              lecturer
              description
              chapters {
                id
                courseId
                name
                position
              }
            }
          }
        }
        GQL
      end
      let(:course) { FactoryBot.create(:course, :with_chapters_and_units) }

      context "succeed" do
        let(:chapters) { Chapter.where("course_id": course.id) }
        let(:chapters_order) do
          chapters = Chapter.where("course_id": course.id)
          chapters.reverse()
          puts "chapters: #{JSON.pretty_generate(chapters.to_json)}"
          chapters.each_with_index.map do |ch, i|
            ch.position = chapters.length - 1 - i
          end
          chapters.map { |ch| [ch.id, ch.position] }.to_h
        end
        let(:variables) do
          {
            "input": {
              "courseId": course.id,
              "chaptersInput": chapters_order,
            },
          }
        end

        it "reorder chpaters in a course" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{JSON.pretty_generate(body)}"
          data = body["data"]["chapterReorder"]["course"]
          error = body["data"]["chapterReorder"]["error"]

          want_chapters = Chapter.where(course_id: course.id).map do |ch|
            {
              id: ch.id.to_s,
              name: ch.name,
              position: ch.position,
              courseId: ch.course_id,
            }
          end

          expect(error).to be_nil
          expect(data).to include(
            "name" => course.name,
            "lecturer" => course.lecturer,
            "description" => course.description,
            "chapters" => want_chapters.as_json,
            # "chapters" => chapters.map { |ch| ch.to_h },
          )
        end
      end
    end
  end
end
