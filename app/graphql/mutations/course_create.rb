# frozen_string_literal: true

require "json"

module Mutations
  class CourseCreate < BaseMutation
    # add
    description "Creates a new course"

    field :course, Types::CourseType, null: true
    field :error, String, null: false

    argument :input, Types::CourseInputType, required: true

    def resolve(input:)
      course_attrs = input.to_h.except(:chapters)

      course_error = {}

      course = ::Course.new(course_attrs)
      course.save unless course.valid?
      course_error[:lecturer] = course.errors.messages[:lecturer].join if course.errors.messages[:lecturer]

      chapter_attrs = input[:chapters]
      chapters_errors = []

      chapters = chapter_attrs.each_with_index.map do |chapter_attr, i|
        chapter_error = {}
        units_errors = []
        args = chapter_attr.to_h.except(:units)
        args[:course_id] = course.id
        args[:position] = i

        chapter = ::Chapter.new(args)
        chapter.save unless chapter.valid?

        unit_attrs = chapter_attr[:units]
        chapter.units = unit_attrs.each_with_index.map do |unit_attr, j|
          args = unit_attr.to_h
          args[:chapter_id] = chapter.id
          args[:position] = j
          unit = ::Unit.new(args)
          unit.save unless unit.valid?
          units_errors << unit.errors.messages[:name].join if unit.errors.messages[:name]
          unit
        end

        chapter_error[:units] = units_errors unless units_errors.empty?
        chapters_errors << chapter_error unless chapter_error.empty? # Only add chapter errors if there are any
        chapter
      end

      course_error[:chapters] = chapters_errors unless chapters_errors.empty?

      return { course: nil, error: course_error.to_json } unless course.valid? && chapters_errors.empty?

      course.chapters = chapters
      { course: course, error: nil }
    end

    # def resolve(input:)
    #   course_attrs = input.to_h.except(:chapters)

    #   course_error = {}
    #   course_error[:chapters] = []

    #   course = ::Course.new(course_attrs)
    #   if course.valid?
    #     course = course.save
    #   else
    #     course_error.merge!(course.errors.messages.except(:course))
    #   end

    #   puts "course.eerror: #{course.errors.to_json}"

    #   puts "course.eerror: #{course_error}"

    #   chapter_attrs = input[:chapters]

    #   # TODO: Maybe we can use ::Chapter.build to solve this
    #   chapters = chapter_attrs.each_with_index.map do |chapter_attr, i|
    #     chapter_error = {}
    #     chapter_error[:units] = []
    #     args = chapter_attr.to_h.except(:units)
    #     args[:course_id] = course.id
    #     args[:position] = i

    #     chapter = ::Chapter.new(args)
    #     if chapter.valid?
    #       chapter = chapter.save
    #     else
    #       chapter_error.merge!(chapter.errors.messages.except(:chapter))
    #     end

    #     # set up units in this chapter
    #     unit_attrs = chapter_attr[:units]
    #     chapter.units = unit_attrs.each_with_index.map do |unit_attr, j|
    #       args = unit_attr.to_h
    #       args[:chapter_id] = chapter.id
    #       args[:position] = j
    #       unit = ::Unit.new(args)
    #       if unit.valid?
    #         unit.save!
    #       else
    #         chapter_error[:units] << unit.errors.messages.except(:chapter)
    #       end
    #       unit
    #     end
    #     course_error[:chapters] << chapter_error unless chapter_error.empty?
    #     chapter
    #   end

    #   puts "errors: #{course_error}"
    #   return { course: nil, error: course_error.to_json } unless course.valid?

    #   course.chapters = chapters

    #   puts "at here"

    #   { course: nil, error: course.errors.full_messages.join } unless course.save

    #   # raise GraphQL::ExecutionError.new "Error creating course", extensions: course.errors.to_hash unless course.save
    #   { course: course, error: nil }
    # end
  end
end
