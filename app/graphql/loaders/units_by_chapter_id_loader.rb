# frozen_string_literal: true

module Loaders
  class UnitsByChapterIdLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(chapter_ids)
      units_by_chapter_id = @model.where(chapter_id: chapter_ids).group_by(&:chapter_id)
      units_by_chapter_id.each do |chapter_id, units|
        fulfill(chapter_id, units)
      end
      chapter_ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
      chapter_ids
    end
  end
end