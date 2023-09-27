FactoryBot.define do
  factory :chapter do
    name { Faker::Book.name }
    sequence(:position) { |n| n }
  end
end
