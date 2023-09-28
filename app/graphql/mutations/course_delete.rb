# frozen_string_literal: true

module Mutations
  class CourseDelete < BaseMutation
    description "Deletes a course by ID"

    field :course, Types::CourseType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      course = ::Course.find(id)
      raise GraphQL::ExecutionError.new "Error deleting course", extensions: course.errors.to_hash unless course.destroy

      { course: course }
    end
  end
end
