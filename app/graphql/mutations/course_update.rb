# frozen_string_literal: true

module Mutations
  class CourseUpdate < BaseMutation
    description "Updates a course by id"

    field :course, Types::CourseType, null: false

    argument :id, ID, required: true
    argument :input, Types::CourseInputType, required: true

    def resolve(id:, input:)
      course = ::Course.find(id)
      # TODO: in model layer, validate :position
      { course: nil, errors: course.errors.full_messages } unless course.update(**input)
      { course: course }
    end
  end
end
