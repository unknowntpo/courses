module Types
  class MutationType < Types::BaseObject
    field :unit_delete, mutation: Mutations::UnitDelete
    field :chapter_delete, mutation: Mutations::ChapterDelete
    field :course_delete, mutation: Mutations::CourseDelete
    field :unit_update, mutation: Mutations::UnitUpdate
    field :chapter_update, mutation: Mutations::ChapterUpdate
    field :course_update, mutation: Mutations::CourseUpdate
    field :course_create, mutation: Mutations::CourseCreate
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
