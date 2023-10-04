# The Unit class represents a unit within a chapter.
# Each unit belongs to a chapter and requires a name, content, and position to be present.
#
# @!attribute [rw] name
#   @return [String] The name of the unit.
# @!attribute [rw] content
#   @return [String] The content of the unit.
# @!attribute [rw] position
#   @return [Integer] The position of the unit within its chapter.
# @!attribute [rw] chapter
#   @return [Chapter] The chapter to which this unit belongs.
class Unit < ApplicationRecord
  # @!attribute [rw] chapter
  #   The chapter to which this unit belongs. This association is optional.
  belongs_to :chapter, :optional => true

  # Validates the presence of a name, content, and position for this unit.
  validates_presence_of :name, :content, :position

  # Validates the presence of a chapter for this unit, unless validation is being skipped.
  validates :chapter, presence: true, unless: -> { validation_context == :skip_chapter }
end
