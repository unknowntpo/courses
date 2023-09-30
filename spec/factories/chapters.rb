FactoryBot.define do
  factory :chapter do
    name { Faker::Name.name }
    course
    sequence(:position) { |n| n - 1 }

    trait :with_units do
      after(:create) do |chapter|
        create_list(:unit, 2, chapter: chapter)
      end
    end
  end
end
