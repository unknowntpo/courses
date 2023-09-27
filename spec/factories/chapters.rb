FactoryBot.define do
  factory :chapter do
    name { Faker::Name.name }
    sequence(:position) { |n| n }
  end
end
