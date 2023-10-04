# The Chapter class represents a chapter within a course.
# Each chapter belongs to a course and can have multiple units.
# It requires a name to be present and can accept nested attributes for its units.
#
# @!attribute [rw] name
#   @return [String] The name of the chapter.
# @!attribute [rw] course
#   @return [Course] The course to which this chapter belongs.
# @!attribute [rw] units
#   @return [Array<Unit>] The units contained in this chapter.
class Chapter < ApplicationRecord
  # @!attribute [rw] course
  #   The course to which this chapter belongs. This association is optional.
  belongs_to :course, :optional => true

  # @!attribute [rw] units
  #   The units contained in this chapter. If a chapter is destroyed, its units will also be destroyed.
  has_many :units, :dependent => :destroy

  # Validates the presence of a name for this chapter.
  validates_presence_of :name

  # Validates the presence of a course for this chapter, unless validation is being skipped.
  validates :course, presence: true, unless: -> { validation_context == :skip_course }

  # Allows the acceptance of nested attributes for units.
  accepts_nested_attributes_for :units
end
