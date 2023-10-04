# frozen_string_literal: true

module Mutations
  class ChapterUpdate < BaseMutation
    description "Updates a chapter by id"

    field :chapter, Types::ChapterType, null: true
    field :error, GraphQL::Types::JSON, null: true

    argument :id, ID, required: true
    argument :input, Types::ChapterInputType, required: true

    def resolve(id:, input:)
      begin
        @chapter = ::Chapter.find(id)
      rescue ActiveRecord::RecordNotFound
        return { chapter: nil, error: { message: "Chapter not found" } }
      end

      input_h = input.to_h

      @chapter.assign_attributes(input_h.except(:chapters))
      puts "course input: #{JSON.pretty_generate(@chapter.as_json)}"

      errors = {}

      unless @chapter.valid?
        return { chapter: nil, error: { "chapter": @chapter.errors } }
      end
      { chapter: nil, error: { message: "failed to update" } } unless Chapter.where(:id => id).update(@chapter.attributes)
      { chapter: @chapter.reload, error: nil }
    end
  end
end
