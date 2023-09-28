# frozen_string_literal: true

module Mutations
  class CourseCreate < BaseMutation
    description "Creates a new course"

    field :course, Types::CourseType, null: false

    argument :course_input, Types::CourseInputType, required: true

    def resolve(course_input:)
      course = ::Course.new(**course_input)
      raise GraphQL::ExecutionError.new "Error creating course", extensions: course.errors.to_hash unless course.save

      { course: course }
    end
  end
end
