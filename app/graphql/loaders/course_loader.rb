module Loaders
  class CourseLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(ids)
      @model.where(id: ids).each { |course| fulfill(course.id, course) }
    end
  end
end
