# frozen_string_literal: true

module Types
  class UnitType < Types::BaseObject
    field :id, ID, null: false
    field :name, String
    field :description, String
    field :content, String
    field :chapter_id, Integer, null: false
    field :position, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
