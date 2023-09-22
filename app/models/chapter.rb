class Chapter < ApplicationRecord
  belongs_to :course
  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  validate :position, uniqueness: true 
end
