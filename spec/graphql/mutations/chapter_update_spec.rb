require "rails_helper"

module Mutations
  RSpec.describe Mutations::ChapterUpdate, type: :request do
    context "update chapter" do
      let(:mutation) do
        <<-GQL
      mutation chapterUpdate($input: ChapterUpdateInput!) {
        chapterUpdate(input: $input) {
          error
          chapter {
            id
            name
          }
        }
      }
        GQL
      end
      let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      let!(:chapter) do
        puts "course: #{course.to_json} "
        Chapter.where(course_id: course.id).limit(1)[0]
      end
      context "succeed" do
        let!(:variables) do
          {
            "input": {
              "id": chapter.id,
              "input": {
                "name": "new Chapter",
              },
            },
          }
        end

        it "updates a chapter" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{body.inspect}"
          data = body["data"]["chapterUpdate"]["chapter"]

          puts "chapter:#{chapter}"

          updated_chapter = Chapter.find(chapter.id)
          expect(updated_chapter.name).to eq(variables[:input][:input][:name])

          expect(data).to include(
            "id" => chapter.id.to_s,
            "name" => variables[:input][:input][:name],
          )
        end
      end
      context "failed" do
        let(:variables) do
          {
            "input": {
              "id": chapter.id,
              "input": {
                "name": "",
              },
            },
          }
        end

        it "invalid field should be annotated" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          data = body["data"]["chapterUpdate"]["chapter"]
          error = body["data"]["chapterUpdate"]["error"]

          expect(data).to be_nil
          expect(error["chapter"]).to include(
            "name" => ["can't be blank"],
          )
        end
      end
    end
  end
end
