module Types
  class MutationType < Types::BaseObject
    field :course_create, mutation: Mutations::CourseCreate, description: "Create a course with chapters and units"
    field :course_delete, mutation: Mutations::CourseDelete, description: "Delete a course and its chapters and units"
    field :course_update, mutation: Mutations::CourseUpdate, description: "Update fields in a course"

    field :chapter_update, mutation: Mutations::ChapterUpdate, description: "Update fields in a chapter"
    field :chapter_reorder, mutation: Mutations::ChapterReorder, description: "Reorder chapters in a course"

    field :unit_update, mutation: Mutations::UnitUpdate, description: "Update fields in a unit"
  end
end
