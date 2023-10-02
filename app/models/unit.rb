class Unit < ApplicationRecord
  belongs_to :chapter
  validates_presence_of :name, :description, :content
  validates :position, uniqueness: { scope: :chapter_id }
end
