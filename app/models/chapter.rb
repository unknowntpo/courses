class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units

  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  validates :position, uniqueness: true
end
