module Resolvers
  class GetUnits < GraphQL::Schema::Resolver
    def resolve
      unit_loader.load(object.id)
    end

    private

    def unit_loader
      Loaders::UnitLoader.for(:unit_loader)
    end
  end
end
