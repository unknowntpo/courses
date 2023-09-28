# frozen_string_literal: true

module Mutations
  class CourseUpdate < BaseMutation
    description "Updates a course by id"

    field :course, Types::CourseType, null: false

    argument :id, ID, required: true
    argument :course_input, Types::CourseInputType, required: true

    def resolve(id:, course_input:)
      course = ::Course.find(id)
      raise GraphQL::ExecutionError.new "Error updating course", extensions: course.errors.to_hash unless course.update(**course_input)

      { course: course }
    end
  end
end
