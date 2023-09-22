
require 'faker'
class Course < ApplicationRecord
    validates_presence_of :name, :lecturer

    def find_by_number!
      # TODO: complete the imlementation
        {
            :name => Faker::ProgrammingLanguage.name,
            :lecturer => Faker::ProgrammingLanguage.creator 
        }
    end
end
