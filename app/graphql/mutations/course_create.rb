# frozen_string_literal: true

module Mutations
  class CourseCreate < BaseMutation
    description "Creates a new course"

    field :course, Types::CourseType, null: true

    argument :input, Types::CourseInputType, required: true

    def resolve(input:)
      course_attrs = input.to_h.except(:chapters)
      course = ::Course.new(course_attrs)
      chapter_attrs = input[:chapters]

      # TODO: Maybe we can use ::Chapter.build to solve this
      chapters = chapter_attrs.each_with_index.map do |chapter_attr, i|
        args = chapter_attr.to_h.except(:units)
        args[:course_id] = course.id
        args[:position] = i

        chapter = ::Chapter.new(args)

        # set up units in this chapter
        unit_attrs = chapter_attr[:units]
        chapter.units = unit_attrs.each_with_index.map do |unit_attr, j|
          args = unit_attr.to_h
          args[:chapter_id] = chapter.id
          args[:position] = j
          ::Unit.new(args)
        end
        chapter
      end

      puts "errors: #{course.errors.full_messages}"
      return { course: nil, errors: course.errors.full_messages } unless course.valid?

      course.chapters = chapters

      { course: nil, errors: course.errors.full_messages } unless course.save

      # raise GraphQL::ExecutionError.new "Error creating course", extensions: course.errors.to_hash unless course.save
      { course: course }
    end
  end
end
