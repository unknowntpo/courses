require 'faker'

FactoryBot.define do
  factory :course do
    name { Faker::Name.name }
    lecturer { Faker::Name.name }
    description { Faker::Lorem.word }

    trait :with_chapters_and_units do
      after(:create) do |course|
        create_list(:chapter, 2, course: course) do |chapter|
          create_list(:unit, 2, chapter: chapter)
        end
      end
    end
  end
end
