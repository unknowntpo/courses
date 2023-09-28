# frozen_string_literal: true

module Mutations
  class ChapterUpdate < BaseMutation
    description "Updates a chapter by id"

    field :chapter, Types::ChapterType, null: false

    argument :id, ID, required: true
    argument :chapter_input, Types::ChapterInputType, required: true

    def resolve(id:, chapter_input:)
      chapter = ::Chapter.find(id)
      raise GraphQL::ExecutionError.new "Error updating chapter", extensions: chapter.errors.to_hash unless chapter.update(**chapter_input)

      { chapter: chapter }
    end
  end
end
