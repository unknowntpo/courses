# frozen_string_literal: true
require "rails_helper"
require "json"

RSpec.describe Loaders::UnitsByChapterIdLoader do
  let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
  let!(:units) { Chapter.where(course_id: course.id) }
  let!(:chapter_ids) { units.map { |chapter| chapter.id } }

  it "should load many units" do
    result = GraphQL::Batch.batch do
      Loaders::UnitsByChapterIdLoader.for(Unit).load_many(chapter_ids)
    end
    puts "result: #{result}"
    result.each_with_index do |units, i|
      units.each { |unit| expect(unit.chapter_id).to eq(chapter_ids[i]) }
    end
  end
end
