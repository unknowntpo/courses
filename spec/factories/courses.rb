FactoryBot.define do
  factory :course do
    name { "Sample Course Name" }
    lecturer { "Sample lecturer Name"}
    description { "Sample Course Description" }
    # add other default attributes here as needed
  end
end