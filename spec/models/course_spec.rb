require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'validation' do
    it 'name should be present' do
      course = Course.new()
      puts "course: #{course.inspect}"
      expect(course).not_to be_valid
      expect(course.errors[:name]).to include("can't be blank")
      expect(course.errors[:lecturer]).to include("can't be blank")
      expect(course.errors[:description]).to include("can't be blank")
      expect(course.errors[:chapters]).to include("can't be blank")
    end
  end
end

