# frozen_string_literal: true

module Types
  class UnitInputType < Types::BaseInputObject
    argument :name, String, required: false
    argument :description, String, required: false
    argument :content, String, required: false
  end
end
