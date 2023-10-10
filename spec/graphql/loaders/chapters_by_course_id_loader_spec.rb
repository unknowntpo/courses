require "rails_helper"
require "json"

RSpec.describe Loaders::ChaptersByCourseIdLoader do

  let!(:course_ids) do
    course1 = FactoryBot.create(:course, :with_chapters_and_units)
    course2 = FactoryBot.create(:course, :with_chapters_and_units)
    [course1.id, course2.id]
  end
  # let!(:ids) {
  #   Chapter.where(course_id: [course1.id, course2.id]).map { |chapter| chapter.id }
  # }

  describe "when we load chapters from loader" do
    it "should load many courses" do
      result = GraphQL::Batch.batch do
        Loaders::ChaptersByCourseIdLoader.for(Chapter).load_many(course_ids)
      end
      puts "result: #{result}"
      result.each_with_index do |chapters, i|
        chapters.each { |chapter| expect(chapter.course_id).to eq(course_ids[i]) }
      end
    end
  end
end
