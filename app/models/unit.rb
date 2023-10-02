class Unit < ApplicationRecord
  belongs_to :chapter
  validates_presence_of :name, :content, :position
end
