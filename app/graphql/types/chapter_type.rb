# frozen_string_literal: true

module Types
  class ChapterType < Types::BaseObject
    field :id, ID
    field :name, String
    field :course_id, Integer
    field :position, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
    field :units, [UnitType]
  end
end
