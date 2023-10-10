# frozen_string_literal: true

module Types
  class CourseType < Types::BaseObject
    field :id, ID
    field :name, String
    field :lecturer, String
    field :description, String
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
    # field :chapters, [ChapterType], null: false,
    # resolver: Resolvers::GetChapters
    field :chapters, [ChapterType], null: false

    def chapters
      puts "objectid: #{object.as_json}"
      Loaders::ChaptersByCourseIdLoader.for(Chapter).load([object.id])
      # puts "chapters: #{chapters}"
      # chapters
      # Event, :category_id, merge: -> { order(id: :asc) }
    end
  end
end
