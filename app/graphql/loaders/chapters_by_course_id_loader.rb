module Loaders
  class ChaptersByCourseIdLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    #
    # def perform(course_id)
    #   # puts "#{a}"
    #   puts "#{course_id}"
    #   chapters = @model.where(course_id: course_id)
    #   puts "chapters: #{chapters.as_json}"
    #   fulfill(course_id, chapters)
    #   chapters
    #
    # end

    def perform(course_ids)
      course_ids.each do |course_id|
        chapters = @model.where(course_id: course_id)
        fulfill(course_id, chapters)
      end
    end
  end
end