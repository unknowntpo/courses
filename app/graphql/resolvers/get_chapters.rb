module Resolvers
  class GetChapters < GraphQL::Schema::Resolver
    def resolve
      ChapterLoader.for(Chapter).load(object.id)
    end

    # private

    # def chapter_loader
    #   Loaders::ChapterLoader.for(:chapter_loader)
    # end
  end
end
