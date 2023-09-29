require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'validation' do
    it 'name should be present' do
      chapter = Chapter.new()
      puts "chapter: #{chapter.inspect}"
      expect(chapter).not_to be_valid
      expect(chapter.errors[:name]).to include("can't be blank")
      expect(chapter.errors[:units]).to include("can't be blank")
    end
  end
end
