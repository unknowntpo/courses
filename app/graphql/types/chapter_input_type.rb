# frozen_string_literal: true

module Types
  class ChapterInputType < Types::BaseInputObject
    argument :name, String, required: true
    argument :units, [UnitInputType], required: true
  end
end
