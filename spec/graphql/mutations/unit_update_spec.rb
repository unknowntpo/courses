require "rails_helper"

module Mutations
  RSpec.describe Mutations::UnitUpdate, type: :request do
    context "update unit" do
      let(:mutation) do
        <<-GQL
      mutation unitUpdate($input: UnitUpdateInput!) {
        unitUpdate(input: $input) {
          error
          unit {
            id
            name
          }
        }
      }
        GQL
      end
      let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      let!(:unit) do
        puts "course: #{course.to_json} "
        chapter = Chapter.where(course_id: course.id).limit(1)[0]
        unit = Unit.where(chapter_id: chapter.id).limit(1)[0]
        unit
      end
      context "succeed" do
        let!(:variables) do
          {
            "input": {
              "id": unit.id,
              "input": {
                "name": "new Unit",
              },
            },
          }
        end

        it "updates a unit" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{body.inspect}"
          data = body["data"]["unitUpdate"]["unit"]

          puts "unit:#{unit}"

          updated_unit = Unit.find(unit.id)
          expect(updated_unit.name).to eq(variables[:input][:input][:name])

          expect(data).to include(
            "id" => unit.id.to_s,
            "name" => variables[:input][:input][:name],
          )
        end
      end
      context "failed" do
        let(:variables) do
          {
            "input": {
              "id": unit.id,
              "input": {
                "name": "",
                "content": "",
              },
            },
          }
        end

        it "invalid field should be annotated" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          data = body["data"]["unitUpdate"]["unit"]
          error = body["data"]["unitUpdate"]["error"]

          expect(data).to be_nil
          expect(error["unit"]).to include(
            "name" => ["can't be blank"],
            "content" => ["can't be blank"],
          )
        end
      end
    end
  end
end
