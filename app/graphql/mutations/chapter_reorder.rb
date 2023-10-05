# frozen_string_literal: true

require "json"

module Mutations
  class ChapterReorder < BaseMutation
    description "Reorder the chapter"

    field :course, Types::CourseType, null: true
    field :error, GraphQL::Types::JSON, null: true

    argument :course_id, ID, "The id of course", required: true

    argument :chapters_input, GraphQL::Types::JSON, required: true, description: 'A hash where the key is chapter.id and the value is the desired position,
 There are some spec of this chapters_input:
 - all keys (chapters.id) must belongs to the course_id, and every chapter.id belongs to course_id should be provided.
 - position should be in the range [0, chapters.length)
 - The position should not overlapped. e.g. This input overlapped at position 1, {"33": 0, "34": 0, "35": 1}'

    # chapters_input is a hash from chapter_id (string) to position (int)
    def resolve(course_id:, chapters_input:)
      # First, validate the course.

      Course.transaction do
        course = Course.find(course_id)
        unless course
          raise GraphQL::ExecutionError, "Course not found course_id: #{course_id}"
        end
        puts "chapters_input: #{JSON.pretty_generate(chapters_input)}"

        # Find the chapters based on the given criteria.

        @chapters = ::Chapter.where(course_id: course_id)

        # If you need to reorder based on chapters_input, you can do it here.
        # For simplicity, I'm skipping that part.

        # If chapters aren't found or some other error occurs
        if @chapters.empty?
          raise GraphQL::ExecutionError, "No chapters found"
        end

        # if length not match, then return error
        unless @chapters.length == chapters_input.length
          raise GraphQL::ExecutionError, "should provide all chapters whose course_id is #{course_id}"
        end

        overlapped_ids = get_overlapped_ids(chapters_input)

        puts "length: #{overlapped_ids.length}"
        unless overlapped_ids.length == 0
          e = {
            "cause": "has position overlapped ids",
            "overlapped ids": overlapped_ids,
          }
          puts "e: #{e}"
          return { course: nil, error: e }
        end

        puts "overlapped_ids: #{overlapped_ids.inspect}"

        pos_out_of_bound_input = get_pos_out_of_bound_ids(chapters_input)
        unless pos_out_of_bound_input.length == 0
          e = {
            "cause" => "position out-of-bound",
            "position out-of-bound chapters_input" => pos_out_of_bound_input,
          }
          return { course: nil, error: e }
        end

        puts "in resolver: chapters: #{JSON.pretty_generate(@chapters.as_json)}"
        # puts "chapters: #{chapters.to_json}"

        @chapters.each do |chapter|
          puts "chapter: #{chapter.inspect}"
          chapter.update(position: chapters_input[chapter.id.to_s])
        end

        # Return the course (as per your field definition)
        { course: course, error: nil }
      end
    rescue ActiveRecord::Rollback, GraphQL::ExecutionError => e
      puts "e: #{e}"
      { course: nil, error: e.message }
    end

    private

    # get_pos_out_of_bound_ids gets the ids which position is not in
    # valid range [0, chapters_input.length)
    def get_pos_out_of_bound_ids(chapters_input)
      len = chapters_input.length
      chapters_input.select { |id, pos| pos >= len }
    end

    # chapters_input will be Hash from chapter_id (String) to position (Int)
    def get_overlapped_ids(chapters_input)
      # Group chapters by overlapping positions
      result = Hash.new { |hash, key| hash[key] = [] }

      chapters_input.each do |chapter_id, position|
        result[position] << chapter_id.to_i
      end

      result.select { |_, chapter_ids| chapter_ids.size > 1 }
    end
  end
end
