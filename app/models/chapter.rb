class Chapter < ApplicationRecord
  belongs_to :course
  has_many :units, :dependent => :destroy
  validates_presence_of :name
  accepts_nested_attributes_for :units
end
