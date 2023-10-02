# frozen_string_literal: true

require "json"

module Mutations
  class CourseCreate < BaseMutation
    description "Creates a new course"

    field :course, Types::CourseType, null: true
    field :error, String, null: true

    argument :input, Types::CourseInputType, required: true

    # new resolve

    def resolve(input:)
      course_attrs = input.to_h.symbolize_keys
      errors = validate_input(course_attrs)

      return { course: nil, error: errors.to_json } if errors.any?

      # Start transaction and create records
      course = nil
      Course.transaction do
        course = Course.create!(course_attrs.except(:chapters))
        course_attrs[:chapters].each do |chapter_attr|
          chapter_attr[:course_id] = course.id
          chapter = Chapter.create!(chapter_attr.to_h.except(:units))
          chapter_attr["units"]&.each do |unit_attr|
            unit_attr[:chapter_id] = chapter.id
            unit = Unit.create!(unit_attr.to_h)
          end
        end
      end

      course = Course.includes(chapters: :units).find(course.id)
      { course: course, error: nil }
    rescue ActiveRecord::Rollback => e
      # Handle any unexpected exceptions here.
      { course: nil, error: { base: e.message } }
    end

    def validate_input(attrs)
      errors = {}

      # 1. Validate course
      course = Course.new(attrs.except(:chapters))
      errors.merge!(course.errors.messages) unless course.valid?

      # 2. Validate chapters

      chapters_errors = []
      attrs[:chapters]&.each_with_index do |chapter_attr, chapter_index|
        chapter_error = validate_chapter(chapter_attr, chapter_index)
        puts "chapter_error: #{chapter_error}"
        chapters_errors << chapter_error unless chapter_error.empty?
      end

      puts "chapters_errors length #{chapters_errors.length > 0}"

      errors[:chapters] = chapters_errors if chapters_errors.length > 0

      puts "errors: #{JSON.pretty_generate(errors)}"

      errors
    end

    # return chapter_error
    def validate_chapter(chapter_attr, chapter_index)
      chapter_error = {}
      units_errors = []

      # validates units under this chapter
      chapter_attr[:units]&.each_with_index do |unit_attr, unit_index|
        unit_error = validate_unit(unit_attr, unit_index)
        units_errors << unit_error unless unit_error.empty?
      end
      chapter_error[:units] = units_errors if units_errors.length > 0

      # set position attr
      chapter_attr[:position] = chapter_index
      chapter = ::Chapter.new(chapter_attr.except(:units))

      unless chapter.valid?(:skip_course)
        puts "chapter not valid"
        chapter_error.merge!({ :_index => chapter_index }.merge!(chapter.errors.messages.except(:course)))
      else
        puts "chapter is valid"
        # chapter has no error, but units might have some error
        if chapter_error.has_key? :units
          return chapter_error.merge!({ :_index => chapter_index }.merge!(chapter.errors.messages.except(:course)))
        else
          {}
        end
      end
    end

    # should return error hash of this unit
    def validate_unit(unit_attr, unit_index)
      puts "unit_ttr:#{unit_attr}"

      unit_attr[:position] = unit_index

      unit = ::Unit.new(unit_attr)
      unless unit.valid?(:skip_chapter)
        puts "invalid unit, #{unit.errors.messages.inspect}"
        { :_index => unit_index }.merge(unit.errors.messages.except(:chapter))
      else
        puts "unit valid"
        {}
      end
    end
  end
end
