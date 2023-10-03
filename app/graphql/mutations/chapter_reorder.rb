# frozen_string_literal: true

require "json"

module Mutations
  class ChapterReorder < BaseMutation
    description "Reorder the chapter"

    field :course, Types::CourseType, null: true

    field :error, GraphQL::Types::JSON, null: true

    argument :course_id, ID, "The id of course", required: true

    argument :chapters_input, GraphQL::Types::JSON, "A hash where the key is chapter.id and the value is the desired position", required: true

    # chapters_input is a hash from chapter_id (string) to position (int)
    def resolve(course_id:, chapters_input:)
      # First, validate the course.

      Course.transaction do
        course = Course.find(course_id)
        unless course
          raise GraphQL::ExecutionError, "Course not found"
        end
        puts "chapters_input: #{JSON.pretty_generate(chapters_input)}"

        # Find the chapters based on the given criteria.
        chapters = ::Chapter.where(id: chapters_input.keys, course_id: course_id)

        # If you need to reorder based on chapters_input, you can do it here.
        # For simplicity, I'm skipping that part.

        # if length not match, then return error

        puts "chapters: #{JSON.pretty_generate(chapters.as_json)}"
        # puts "chapters: #{chapters.to_json}"

        chapters.each do |chapter|
          puts "chapter: #{chapter.inspect}"
          chapter.update(position: chapters_input[chapter.id.to_s])
        end

        # If chapters aren't found or some other error occurs
        if chapters.empty?
          raise GraphQL::ExecutionError, "No chapters found or error updating chapters"
        end

        # Return the course (as per your field definition)
        { course: course, error: nil }
      end
    rescue ActiveRecord::Rollback, GraphQL::ExecutionError => e
      { course: nil, error: { "cause": "#{e}" } }
    end
  end
end
