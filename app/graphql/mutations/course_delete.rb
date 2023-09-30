# frozen_string_literal: true

module Mutations
  class CourseDelete < BaseMutation
    description "Deletes a course by ID"

    field :course, Types::CourseType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      course = ::Course.find(id)
      { course: nil, errors: course.errors.full_messages } unless course.destroy
      { course: course }
    end
  end
end
