class Chapter < ApplicationRecord
  belongs_to :course, :optional => true
  has_many :units, :dependent => :destroy
  validates_presence_of :name
  validates :course, presence: true, unless: -> { validation_context == :skip_course }

  accepts_nested_attributes_for :units
end
