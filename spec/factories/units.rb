FactoryBot.define do
  factory :unit do
    chapter
    name { Faker::Name.name }
    description { Faker::Lorem.word }
    content { Faker::Lorem.word }
    sequence(:position) { |n| n }
    # add other default attributes here as needed
  end
end
