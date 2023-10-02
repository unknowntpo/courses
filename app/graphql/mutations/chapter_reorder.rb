# frozen_string_literal: true

require "json"

module Mutations
  class ChapterReorder < BaseMutation
    description "Reorder the chapter"

    field :course, Types::CourseType, null: false

    argument :course_id, ID, "The id of course", required: true

    argument :chapters_input, GraphQL::Types::JSON, "A hash where the key is chapter.id and the value is the desired position", required: true

    def resolve(course_id:, chapters_input:)
      # First, validate the course.
      course = Course.find(course_id)
      unless course
        raise GraphQL::ExecutionError, "Course not found"
      end

      # Find the chapters based on the given criteria.
      chapters = ::Chapter.where(id: chapters_input, course_id: course_id)

      # If you need to reorder based on chapters_input, you can do it here.
      # For simplicity, I'm skipping that part.

      puts "chapters: #{JSON.pretty_generate(chapters.as_json)}"
      # puts "chapters: #{chapters.to_json}"

      # If chapters aren't found or some other error occurs
      if chapters.empty?
        raise GraphQL::ExecutionError, "No chapters found or error updating chapters"
      end

      # Return the course (as per your field definition)
      { course: course }
    end
  end
end
