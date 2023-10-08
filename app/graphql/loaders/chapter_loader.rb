module Loaders
  class ChapterLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(ids)
      @model.where(id: ids).each { |chapter| fulfill(chapter.id, chapter) }
    end
  end
end