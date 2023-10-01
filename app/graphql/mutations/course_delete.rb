# frozen_string_literal: true

module Mutations
  class CourseDelete < BaseMutation
    description "Deletes a course by ID"

    field :course, Types::CourseType, null: true

    field :errors, [String], null: true

    argument :id, ID, required: true

    def resolve(id:)
      begin
        course = ::Course.find(id)
        if course.destroy
          puts "puts destroy"
          { course: course }
        else
          puts "puts atere"
          { course: nil, errors: course.errors.full_messages }
        end
      rescue ActiveRecord::RecordNotFound => e
        puts "puts rescue"

        { course: nil, errors: ["Course not found."] }
      end
    end
  end
end
