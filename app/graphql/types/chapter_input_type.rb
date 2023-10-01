# frozen_string_literal: true

module Types
  class ChapterInputType < Types::BaseInputObject
    argument :id, ID, required: true
    argument :name, String, required: false
    argument :course_id, Int, required: false
    argument :position, Int, required: false
    argument :units, [UnitInputType], required: false
  end
end
