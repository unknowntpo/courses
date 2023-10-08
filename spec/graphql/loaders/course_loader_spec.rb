require "rails_helper"
require "json"

RSpec.describe Loaders::CourseLoader do
  let!(:course1) { FactoryBot.create(:course, :with_chapters_and_units) }
  let!(:course2) { FactoryBot.create(:course, :with_chapters_and_units) }

describe "when we load course from loader" do
    it "should load courses" do
      result = GraphQL::Batch.batch do
        Loaders::CourseLoader.for(Course).load(course1.id)
      end
      expect(result).to eq(course1)
    end
    it "should load many courses" do
      ids = [course1.id, course2.id]
      result = GraphQL::Batch.batch do
        Loaders::CourseLoader.for(Course).load_many(ids)
      end
      puts "result: #{result}"
      expect(result).to contain_exactly(course1, course2)
    end
  end
end
