require "rails_helper"
require "json"

RSpec.describe Course, type: :model do
  describe "create" do
    context "succeed" do
      let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }
      it "should create course and chapter at the same time" do
        expect(course).to be_valid
        expect(Course.count).to eq(1)
        expect(Chapter.count).to eq(2)
        expect(Unit.count).to eq(4)
      end
    end
    context "failed" do
      let(:course) { Course.new() }
      it "name should be present" do
        puts "course: #{course.inspect}"
        expect(course).not_to be_valid
        expect(course.errors[:name]).to include("can't be blank")
        expect(course.errors[:lecturer]).to include("can't be blank")
        # description can be blank
        expect(course.errors[:description]).not_to include("can't be blank")
      end
    end
  end
end
