# Represents an academic course. A course can have many chapters and is associated
# with a specific lecturer.
#
# == Schema Information
#
# Table name: courses
#
# * +id+ :integer          not null, primary key
# * +name+ :string
# * +lecturer+ :string
# * +description+ :text
# * +created_at+ :datetime not null
# * +updated_at+ :datetime not null
#
# == Relationships
#
# has_many :chapters, dependent: :destroy
#
# == Validations
#
# * Validates the presence of +name+.
# * Validates the presence of +lecturer+.
# * +description+ is optional.
# * +chapters+ is valid in graphql layer.
#
# @!attribute [rw] id
#   @return [Integer] The unique identifier of the course.
# @!attribute [rw] name
#   @return [String] The name of the course.
# @!attribute [rw] lecturer
#   @return [String] The name of the lecturer associated with the course.
# @!attribute [rw] description
#   @return [String] A description of the course.
# @!attribute [rw] created_at
#   @return [DateTime] The timestamp when the course was created.
# @!attribute [rw] updated_at
#   @return [DateTime] The timestamp when the course was last updated.
# @!attribute [rw] chapters
#   @return [Array<Chapter>] The chapters associated with the course.
class Course < ApplicationRecord
  # @!attribute [rw] chapters
  #   The chapters associated with the course. If a course is destroyed, its chapters will also be destroyed.
  has_many :chapters, :dependent => :destroy

  # Validates the presence of a name and lecturer for this course.
  validates_presence_of :name, :lecturer

  # Allows the acceptance of nested attributes for chapters.
  accepts_nested_attributes_for :chapters

  after_create :bust_cache

  # Fetches all courses, with caching.
  # @return [Array<Course>] All courses.
  def self.all_courses
    courses = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Course.all.to_a
    end
    logger.info "get all return all elements"
    return courses
  end

  def self.cache_key
    "courses/all"
  end

  private

  def bust_cache
    logger.info "cache is busted"
    Rails.cache.delete(self.class.cache_key)
  end
end
