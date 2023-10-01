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
class Course < ApplicationRecord
  has_many :chapters, :dependent => :destroy
  validates_presence_of :name, :lecturer
  accepts_nested_attributes_for :chapters

  def self.get_all
    # Course.all
    courses = Rails.cache.fetch("courses/all", expires_in: 12.hours) do
      Course.all.to_a
    end
    logger.info "get all return all elements"
    return courses
  end
end
