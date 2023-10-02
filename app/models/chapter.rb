class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, :dependent => :destroy
  validates_presence_of :name
  accepts_nested_attributes_for :units

  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  validates :position, uniqueness: { scope: :course_id }
end
