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
      let!(:chapters) { Chapter.where("course_id": course.id) }
      context "succeed" do
        let!(:chapters_order) do
          chapters = Chapter.where("course_id": course.id)
          chapters.reverse()
          puts "chapters: #{JSON.pretty_generate(chapters.to_json)}"
          chapters.each_with_index.map do |ch, i|
            ch.position = chapters.length - 1 - i
          end
          chapters.map { |ch| [ch.id, ch.position] }.to_h
        end
        let!(:variables) do
          {
            "input": {
              "courseId": course.id,
              "chaptersInput": chapters_order,
            },
          }
        end

        it "reorder chapters in a course" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{JSON.pretty_generate(body)}"
          data = body["data"]["chapterReorder"]["course"]
          error = body["data"]["chapterReorder"]["error"]

          puts "data; #{JSON.pretty_generate(body.to_json)} "

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
      context "failed" do
        context "not providing all chapters" do
          let!(:chapters_order) do
            chapters = Chapter.where("course_id": course.id)
            chapters.reverse()

            # discard 1 element
            chapters = chapters.slice(0, chapters.length - 1)

            puts "chapters: #{JSON.pretty_generate(chapters.to_json)}"

            chapters.each_with_index.map do |ch, i|
              ch.position = chapters.length - 1 - i
            end
            chapters.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:variables) do
            {
              "input": {
                "courseId": course.id,
                "chaptersInput": chapters_order,
              },
            }
          end

          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["chapterReorder"]["course"]
            error = body["data"]["chapterReorder"]["error"]

            expect(error).to eq("should provide all chapters whose course_id is #{course.id}")
            expect(data).to be_nil
          end
        end

        # { 33:0, 34:1, 38:2 } valid
        # { 33:0, 34:3, 38:2 } valid, should return {34:3}

        context "position not in [0, chapters.length)" do
          let!(:chapters_order) do
            chapters = Chapter.where("course_id": course.id)
            chapters.reverse()

            puts "chapters: #{JSON.pretty_generate(chapters.to_json)}"

            chapters.each_with_index.map do |ch, i|
              # make ch of i==0 position out-of-bound
              ch.position = chapters.length - i
            end
            chapters.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:out_of_bound_ids) {
            chapters_order.select { |id, pos| pos >= chapters_order.length }
          }
          let!(:variables) do
            {
              "input": {
                "courseId": course.id,
                "chaptersInput": chapters_order,
              },
            }
          end

          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["chapterReorder"]["course"]
            error = body["data"]["chapterReorder"]["error"]

            puts "chapters_order: #{JSON.pretty_generate(chapters_order)}"

            expect(error).to include(
              "cause" => "position out-of-bound",
              "position out-of-bound chapters_input" => out_of_bound_ids.transform_keys { |id| id.to_s },
            )
            expect(data).to be_nil
          end
        end

        context "has overlapped position" do
          let!(:reordered_chapters) do
            chapters = Chapter.where("course_id": course.id)
            chapters = chapters.reverse()

            puts "chapters: #{JSON.pretty_generate(chapters.to_json)}"

            chapters[0].position = chapters[chapters.length - 1].position
            chapters
          end
          let!(:chapters_order) do
            reordered_chapters.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:overlapped_ids) {
            chapters = reordered_chapters
            puts "chapters: #{JSON.pretty_generate(chapters.as_json)}"
            # it's like {5 => [536, 537]}
            { "#{chapters[0].position}" => [chapters[0].id, chapters[chapters.length - 1].id] }
          }
          let!(:variables) do
            {
              "input": {
                "courseId": course.id,
                "chaptersInput": chapters_order,
              },
            }
          end
          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["chapterReorder"]["course"]
            error = body["data"]["chapterReorder"]["error"]

            puts "error: #{JSON.pretty_generate(error)}"

            expect(error).to include(
              "cause" => "has position overlapped ids",
              "overlapped ids" => overlapped_ids,
            )
            expect(data).to be_nil
          end
        end
      end
    end
  end
end
