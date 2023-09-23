
require 'faker'
class Course < ApplicationRecord
    validates_presence_of :name, :lecturer
    def self.get_all
        # Course.all
        courses = Rails.cache.fetch("courses/all", expires_in: 12.hours) do
          Course.all.to_a
        end
        return courses
    end

    def find_by_number!
      # TODO: complete the imlementation
        {
            :name => Faker::ProgrammingLanguage.name,
            :lecturer => Faker::ProgrammingLanguage.creator 
        }
    end
end
