# module Loaders
#   class ChapterLoader < GraphQL::Batch::Loader
#     def initialize(model)
#       @model = model
#     end

#     # def perform(course_ids)
#     #   Chapter.where(course_id: course_ids).group_by(&:course_id).each do |course_id, chapters|
#     #     fulfill(course_id, chapters)
#     #   end

#     #   course_ids.each { |id| fulfill(id, []) unless fulfilled?(id) }
#     # end

#     def perform(course_ids)
#       Chapter.where(course_id: course_ids).group_by(&:course_id).each { |course_id, chapters| fulfill(course_id, chapters) }
#       course_ids.each { |course_id| fulfill(course_id, []) unless fulfilled?(course_id) }
#     end
#   end

#   class UnitLoader < Dataloader::BatchLoader
#     # def perform(chapter_ids)
#     #   Unit.where(chapter_id: chapter_ids).group_by(&:chapter_id).each do |chapter_id, units|
#     #     fulfill(chapter_id, units)
#     #   end

#     #   chapter_ids.each { |id| fulfill(id, []) unless fulfilled?(id) }
#     # end
#     def perform(chapter_ids)
#       Unit.where(chapter_id: chapter_ids).group_by(&:chapter_id).each { |chapter_id, units| fulfill(chapter_id, units) }
#       chapter_ids.each { |chapter_id| fulfill(chapter_id, []) unless fulfilled?(chapter_id) }
#     end
#   end
# end
