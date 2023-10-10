module Resolvers
  class GetChapters < GraphQL::Schema::Resolver
    def resolve
      # Rails.logger.info "a #{a}"
      # Rails.logger.info "b #{b}"
      # Rails.logger.info "c #{c}"
      # object is a course?
      Loaders::ChaptersByCourseIdLoader.for(Chapter, :course_id, merge: -> { order(id: :asc) }
      ).load(object.id)
    end

    #    def events(first:)
    #   ForeignKeyLoader.for(Event, :category_id, merge: -> { order(id: :asc) }).
    #     load(object.id).then do |records|
    #       records.first(first)
    #     end
    # end

    # private

    # def chapter_loader
    #   Loaders::ChapterLoader.for(:chapter_loader)
    # end
  end
end
