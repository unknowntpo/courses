require "rails_helper"

module Queries
  RSpec.describe "courses", type: :request do
    let(:query) do
      <<~GQL
        query queryCourses($after: String, $before: String, $first: Int, $last: Int) {
          courses(after: $after, before: $before, first: $first, last: $last) {
            pageInfo {
              endCursor
              startCursor
              hasPreviousPage
              hasNextPage
            }
            edges {
              cursor
              node {
                id
                name
                lecturer
                description
                chapters {
                  name
                  position
                  units {
                    name
                    description
                    content
                    position
                  }
                }
              }
            }
          }
        }
      GQL
    end
    describe "query courses" do
      let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      context "succeed" do
        let(:variables) {
          {
            "last": 1,
          }
        }
        it "returns all courses with pagination" do
          # we should use variables.to_json to avoid this error
          # 'Could not coerce value \"1\" to Int'
          # https://github.com/rmosolgo/graphql-ruby/issues/2897#issuecomment-617838748
          post "/graphql", params: { query: query, variables: variables.to_json }

          body = JSON.parse(response.body)
          puts "body: #{JSON.pretty_generate(body)}"
          data = body["data"]["courses"]
          page_info = data["pageInfo"]
          edges = data["edges"]

          puts "edges: #{JSON.pretty_generate(edges)}"

          expect(page_info).to eq(
            "startCursor" => "MQ",
            "endCursor" => "MQ",
            "hasPreviousPage" => false,
            "hasNextPage" => false,
          )

          expect(data).to include(
            "id" => course.id.to_s,
            "name" => course.name,
            "lecturer" => course.lecturer,
            "description" => course.description,
            "chapters" => a_collection_containing_exactly(
              *course.chapters.map do |chapter|
              hash_including(
                "name" => chapter[:name],
                "position" => chapter[:position],
                "units" => a_collection_containing_exactly(
                  *chapter.units.map do |unit|
                  hash_including(
                    "name" => unit[:name],
                    "description" => unit[:description],
                    "content" => unit[:content],
                    "position" => unit[:position],
                  )
                end
                ),
              )
            end
            ),
          )
          # expect(edges).to match_array [
          #                                {
          #                                  "cursor" => "MQ",
          #                                  "node" => hash_including(
          #                                    "name" => "Hero",
          #                                    "userId" => user.id,
          #                                    "year" => 1984,
          #                                    "genre" => "Horror",
          #                                  ),
          #                                },
          #                                {
          #                                  "cursor" => "Mg",
          #                                  "node" => hash_including(
          #                                    "title" => "Gifted",
          #                                    "userId" => user.id,
          #                                    "year" => 1988,
          #                                    "genre" => "Thriller",
          #                                  ),
          #                                },
          #                              ]
        end
      end
    end
  end
end
