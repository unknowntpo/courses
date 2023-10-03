# frozen_string_literal: true
require "json"

module Mutations
  class CourseUpdate < BaseMutation
    description "Updates a course by id"

    field :course, Types::CourseType, null: true
    field :error, GraphQL::Types::JSON, null: true

    argument :id, ID, required: true
    argument :input, Types::CourseInputType, required: true

    def resolve(id:, input:)
      course = ::Course.find(id)

      input_h = input.to_h

      course.assign_attributes(input_h.except(:chapters))
      puts "course input: #{JSON.pretty_generate(course.as_json)}"

      errors = {}

      unless course.valid?
        return { course: nil, error: { "course": course.errors } }
      end
      { course: nil, error: { message: "failed to update" } } unless Course.where(:id => 0).update(course.attributes)
      { course: course.reload, error: nil }
    end
  end
end
