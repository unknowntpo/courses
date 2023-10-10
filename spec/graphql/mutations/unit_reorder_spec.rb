require "rails_helper"

module Mutations
  RSpec.describe Mutations::UnitReorder, type: :request do
    context "reorder unit" do
      let(:mutation) do
        <<-GQL
        mutation unitReorder($input: UnitReorderInput!) {
          unitReorder(input: $input) {
            error
            chapter {
              name
              units {
                id
                chapterId
                name
                description
                content
                position
              }
            }
          }
        }
        GQL
      end
      let(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      let!(:chapter) { Chapter.where("course_id": course.id).limit(1)[0] }
      context "succeed" do
        let!(:units_order) do
          units = ::Unit.where("chapter_id": chapter.id)
          units.reverse()
          puts "units: #{JSON.pretty_generate(units.to_json)}"
          units.each_with_index.map do |ch, i|
            ch.position = units.length - 1 - i
          end
          units.map { |ch| [ch.id, ch.position] }.to_h
        end
        let!(:variables) do
          {
            "input": {
              "chapterId": chapter.id,
              "unitsInput": units_order,
            },
          }
        end

        it "reorder units in a course" do
          post "/graphql", params: { query: mutation, variables: variables.to_json }
          body = JSON.parse(response.body)
          puts "body: #{JSON.pretty_generate(body)}"
          data = body["data"]["unitReorder"]["chapter"]
          error = body["data"]["unitReorder"]["error"]

          puts "data; #{JSON.pretty_generate(body.to_json)} "

          want_units = ::Unit.where(chapter_id: chapter.id).map do |unit|
            {
              id: unit.id.to_s,
              chapterId: unit.chapter_id,
              name: unit.name,
              description: unit.description,
              content: unit.content,
              position: unit.position,
            }
          end

          expect(error).to be_nil
          expect(data).to include(
                            "name" => chapter.name,
                            "units" => want_units.as_json,
                          )
        end
      end
      context "failed" do
        context "not providing all units" do
          let!(:units_order) do
            units = Chapter.where("course_id": course.id)
            units.reverse()

            # discard 1 element
            units = units.slice(0, units.length - 1)

            puts "units: #{JSON.pretty_generate(units.to_json)}"

            units.each_with_index.map do |ch, i|
              ch.position = units.length - 1 - i
            end
            units.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:variables) do
            {
              "input": {
                "chapterId": chapter.id,
                "unitsInput": units_order,
              },
            }
          end

          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["unitReorder"]["chapter"]
            error = body["data"]["unitReorder"]["error"]

            expect(error).to eq("should provide all units whose chapter_id is #{chapter.id}")
            expect(data).to be_nil
          end
        end

        # { 33:0, 34:1, 38:2 } valid
        # { 33:0, 34:3, 38:2 } valid, should return {34:3}

        context "position not in [0, units.length)" do
          let!(:units_order) do
            units = ::Unit.where("chapter_id": chapter.id)
            units.reverse()

            puts "units: #{JSON.pretty_generate(units.to_json)}"

            units.each_with_index.map do |unit, i|
              # make ch of i==0 position out-of-bound
              unit.position = units.length - i
            end
            units.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:out_of_bound_ids) {
            units_order.select { |id, pos| pos >= units_order.length }
          }
          let!(:variables) do
            {
              "input": {
                "chapterId": chapter.id,
                "unitsInput": units_order,
              },
            }
          end

          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["unitReorder"]["chapter"]
            error = body["data"]["unitReorder"]["error"]

            puts "units_order: #{JSON.pretty_generate(units_order)}"

            expect(error).to include(
                               "cause" => "position out-of-bound",
                               "position out-of-bound units_input" => out_of_bound_ids.transform_keys { |id| id.to_s },
                             )
            expect(data).to be_nil
          end
        end

        context "has overlapped position" do
          let!(:reordered_units) do
            units = Chapter.where("course_id": course.id)
            units = units.reverse()

            puts "units: #{JSON.pretty_generate(units.to_json)}"

            units[0].position = units[units.length - 1].position
            units
          end
          let!(:units_order) do
            reordered_units.map { |ch| [ch.id, ch.position] }.to_h
          end
          let!(:overlapped_ids) {
            units = reordered_units
            puts "units: #{JSON.pretty_generate(units.as_json)}"
            # it's like {5 => [536, 537]}
            { "#{units[0].position}" => [units[0].id, units[units.length - 1].id] }
          }
          let!(:variables) do
            {
              "input": {
                "chapterId": chapter.id,
                "unitsInput": units_order,
              },
            }
          end
          it "should return error" do
            post "/graphql", params: { query: mutation, variables: variables.to_json }
            body = JSON.parse(response.body)
            puts "body: #{JSON.pretty_generate(body)}"
            data = body["data"]["unitReorder"]["chapter"]
            error = body["data"]["unitReorder"]["error"]

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
