# frozen_string_literal: true

module Mutations
  class UnitUpdate < BaseMutation
    description "Updates a unit by id"

    field :unit, Types::UnitType, null: false

    argument :id, ID, required: true
    argument :unit_input, Types::UnitInputType, required: true

    def resolve(id:, unit_input:)
      unit = ::Unit.find(id)
      raise GraphQL::ExecutionError.new "Error updating unit", extensions: unit.errors.to_hash unless unit.update(**unit_input)

      { unit: unit }
    end
  end
end
