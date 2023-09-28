module Mutations
  class CreateCourse < Mutations::BaseMutation
    argument :name, String, required: true
    argument :lecturer, String, required: true
    argument :description, String, required: true
    argument :chapters, [Types::ChapterInputType], required: true

    field :course, Types::CourseType, null: false
    field :errors, [String], null: false

    def resolve(name:, lecturer:, description:, chapters:)
      # TODO: insert chapter
      user = ::Course.new(name:, lecturer:, description:)
      return { user: nil, errors: user.errors.full_messages } unless user.valid?

      user.movies.build(movies.map(&:to_h))

      puts "movies: #{user.inspect}"

      if user.save
        puts "#{user.inspect} issaved"
        { user:, errors: [] }
      else
        logger.debug 'has some error'

        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
