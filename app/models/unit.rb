class Unit < ApplicationRecord
  belongs_to :chapter, :optional => true
  validates_presence_of :name, :content, :position
  validates :chapter, presence: true, unless: -> { validation_context == :skip_chapter }
end
