# frozen_string_literal: true

module Loaders
  class UnitsByChapterIdLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(chapter_ids)
      chapter_ids.each do |chapter_id|
        units = @model.where(chapter_id: chapter_id)
        fulfill(chapter_id, units)
      end
    end
  end
end