# frozen_string_literal: true

module Types
  class CourseInputType < Types::BaseInputObject
    argument :name, String, required: true
    argument :lecturer, String, required: true
    argument :description, String, required: true
    argument :chapters, [Types::ChapterInputType], required: true
  end
end
