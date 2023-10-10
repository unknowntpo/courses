# frozen_string_literal: true

require "json"

module Mutations
  class UnitReorder < BaseMutation
    description "Reorder the chapter"

    field :chapter, Types::ChapterType, null: true
    field :error, GraphQL::Types::JSON, null: true

    argument :chapter_id, ID, "The id of chapter", required: true

    argument :units_input, GraphQL::Types::JSON, required: true, description: 'A hash where the key is unit.id and the value is the desired position,
 There are some spec of this chapters_input:
 - all keys (unit.id) must belongs to the course_id, and every chapter.id belongs to course_id should be provided.
 - position should be in the range [0, units.length)
 - The position should not overlapped. e.g. This input overlapped at position 1, {"33": 0, "34": 0, "35": 1}'

    # units_input is a hash from chapter_id (string) to position (int)
    def resolve(chapter_id:, units_input:)
      # First, validate the course.

      Course.transaction do
        chapter = ::Chapter.find(chapter_id)
        unless chapter
          raise GraphQL::ExecutionError, "Course not found course_id: #{chapter_id}"
        end
        puts "chapters_input: #{JSON.pretty_generate(units_input)}"

        @units = ::Unit.where(chapter_id: chapter_id)

        if @units.empty?
          raise GraphQL::ExecutionError, "No units found"
        end

        unless @units.length == units_input.length
          raise GraphQL::ExecutionError, "should provide all units whose chapter_id is #{chapter_id}"
        end

        overlapped_ids = get_overlapped_ids(units_input)

        puts "length: #{overlapped_ids.length}"
        unless overlapped_ids.length == 0
          e = {
            "cause": "has position overlapped ids",
            "overlapped ids": overlapped_ids,
          }
          puts "e: #{e}"
          return { chapter: nil, error: e }
        end

        puts "overlapped_ids: #{overlapped_ids.inspect}"

        pos_out_of_bound_input = get_pos_out_of_bound_ids(units_input)
        unless pos_out_of_bound_input.length == 0
          e = {
            "cause" => "position out-of-bound",
            "position out-of-bound units_input" => pos_out_of_bound_input,
          }
          return { chapter: nil, error: e }
        end

        puts "in resolver: units: #{JSON.pretty_generate(@units.as_json)}"

        @units.each do |unit|
          puts "unit: #{unit.inspect}"
          unit.update(position: units_input[unit.id.to_s])
        end

        # Return the course (as per your field definition)
        { chapter: chapter, error: nil }
      end
    rescue ActiveRecord::Rollback, GraphQL::ExecutionError => e
      puts "e: #{e}"
      { chapter: nil, error: e.message }
    end

    private

    # get_pos_out_of_bound_ids gets the ids which position is not in
    # valid range [0, chapters_input.length)
    def get_pos_out_of_bound_ids(units_input)
      len = units_input.length
      units_input.select { |id, pos| pos >= len }
    end

    # chapters_input will be Hash from chapter_id (String) to position (Int)
    def get_overlapped_ids(units_input)
      # Group chapters by overlapping positions
      result = Hash.new { |hash, key| hash[key] = [] }

      units_input.each do |unit_id, position|
        result[position] << unit_id.to_i
      end

      result.select { |_, unit_ids| unit_ids.size > 1 }
    end
  end
end

