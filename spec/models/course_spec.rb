require 'rails_helper'
require 'json'

RSpec.describe Course, type: :model do
  describe 'validation' do
    it 'name should be present' do
      course = Course.new()
      puts "course: #{course.inspect}"
      expect(course).not_to be_valid
      expect(course.errors[:name]).to include("can't be blank")
      expect(course.errors[:lecturer]).to include("can't be blank")
      expect(course.errors[:description]).to include("can't be blank")
    end
  end
  describe 'create' do
    # What's the
    let!(:course) { FactoryBot.create(:course, :with_chapters_and_units) }

    it 'should create course and chapter at the same time' do
      expect(course).to be_valid
      puts "all coures #{Course.all.to_json}"
      puts "all chapters #{Chapter.all.to_json}"
      puts "all units #{Unit.all.to_json}"

      expect(Course.count).to eq(1)
      expect(Chapter.count).to eq(2)
      expect(Unit.count).to eq(4)
    end

    it 'dup' do
      puts "all courses #{Course.all.to_json}"
      puts "all chapters #{Chapter.all.to_json}"
      puts "all units #{Unit.all.to_json}"

      expect(Course.count).to eq(1)
      expect(Chapter.count).to eq(2)
      expect(Unit.count).to eq(4)
    end
  end
end
