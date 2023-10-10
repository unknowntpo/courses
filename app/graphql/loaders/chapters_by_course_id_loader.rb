module Loaders
  class ChaptersByCourseIdLoader < GraphQL::Batch::Loader
    def initialize(model)
      @model = model
    end

    def perform(course_ids)
      chapters_by_course_id = @model.where(course_id: course_ids).group_by(&:course_id)
      p "group by: #{chapters_by_course_id.inspect}"
      chapters_by_course_id.each do |course_id, chapters|
        fulfill(course_id, chapters)
      end
    end
  end
end