# frozen_string_literal: true

module Mutations
  class UnitDelete < BaseMutation
    description "Deletes a unit by ID"

    field :unit, Types::UnitType, null: false

    argument :id, ID, required: true

    def resolve(id:)
      unit = ::Unit.find(id)
      raise GraphQL::ExecutionError.new "Error deleting unit", extensions: unit.errors.to_hash unless unit.destroy

      { unit: unit }
    end
  end
end
