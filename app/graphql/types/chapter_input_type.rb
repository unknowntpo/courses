# frozen_string_literal: true

module Types
  class ChapterInputType < Types::BaseInputObject
    argument :id, ID, required: false
    argument :name, String, required: false
    argument :course_id, Integer, required: false
    argument :position, Integer, required: false
    argument :created_at, GraphQL::Types::ISO8601DateTime, required: false
    argument :updated_at, GraphQL::Types::ISO8601DateTime, required: false
  end
end
