# frozen_string_literal: true

module Types
  class CourseInputType < Types::BaseInputObject
    argument :name, String, required: false
    argument :lecturer, String, required: false
    argument :description, String, required: false
    argument :chapters, [ChapterInputType], required: false
  end
end
