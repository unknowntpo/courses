require 'faker'

FactoryBot.define do
  factory :course do
    name { Faker::Name.name }
    lecturer { Faker::Name.name }
    description { Faker::Lorem.word }
    # add other default attributes here as needed
  end
end
