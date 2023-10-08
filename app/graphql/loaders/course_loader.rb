module Loaders
  class CourseLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(id)
      puts "model: #{@model.inspect}"
      course = @model.find_by(id: id)
      fulfill(course.id, course)
      course
    end
  end
end
