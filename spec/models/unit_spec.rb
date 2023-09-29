require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe 'validation' do
    it 'name should be present' do
      unit = Unit.new()
      puts "unit: #{unit.inspect}"
      expect(unit).not_to be_valid
      expect(unit.errors[:name]).to include("can't be blank")
      expect(unit.errors[:description]).to include("can't be blank")
      expect(unit.errors[:content]).to include("can't be blank")
    end
  end
end
