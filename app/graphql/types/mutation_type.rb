module Types
  class MutationType < Types::BaseObject
    field :course_create, mutation: Mutations::CourseCreate
    field :course_delete, mutation: Mutations::CourseDelete
    field :course_update, mutation: Mutations::CourseUpdate

    field :chapter_update, mutation: Mutations::ChapterUpdate
    field :chapter_delete, mutation: Mutations::ChapterDelete

    field :unit_delete, mutation: Mutations::UnitDelete
    field :unit_update, mutation: Mutations::UnitUpdate

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
