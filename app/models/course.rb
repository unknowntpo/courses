class Course < ApplicationRecord
  has_many :chapters
  validates_presence_of :name, :lecturer, :description
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
