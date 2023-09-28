# frozen_string_literal: true

module Mutations
  class ChapterDelete < BaseMutation
    description "Deletes a chapter by ID"

    field :chapter, Types::ChapterType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      chapter = ::Chapter.find(id)
      raise GraphQL::ExecutionError.new "Error deleting chapter", extensions: chapter.errors.to_hash unless chapter.destroy

      { chapter: chapter }
    end
  end
end
