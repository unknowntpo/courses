# frozen_string_literal: true
module Mutations
  class UnitUpdate < BaseMutation
    description "Updates a unit by id"

    field :unit, Types::UnitType, null: true, description: "The updated unit."
    field :error, GraphQL::Types::JSON, null: true, description: "errors during update"

    argument :id, ID, required: true, description: "id of the target unit"
    argument :input, Types::UnitInputType, required: true, description: "fields in the target unit you wanna update"

    def resolve(id:, input:)
      begin
        @unit = ::Unit.find(id)
      rescue ActiveRecord::RecordNotFound
        return { unit: nil, error: { message: "unit not found" } }
      end

      input_h = input.to_h

      @unit.assign_attributes(input_h)
      puts "unit input: #{JSON.pretty_generate(@unit.as_json)}"

      unless @unit.valid?
        return { unit: nil, error: { "unit": @unit.errors } }
      end
      { unit: nil, error: { message: "failed to update" } } unless Unit.where(:id => id).update(@unit.attributes)
      { unit: @unit.reload, error: nil }
    end
  end
end
