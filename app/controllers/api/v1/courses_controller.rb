class Api::V1::CoursesController < ApplicationController

  def index
    @courses = Course.get_all
    render json: @courses
  end

  def create
    @course = Course.new(course_params)
    unless @course.valid?
      render json: { "message": 'invalid request', "status": 400 }, status: 400
      return
    end

    if @course.save
      render json: { "data": @course, "status": 200 }, status: 200
    else
      # TODO: handle different type of error
      render json: { "message": 'failed to create new course', "status": 400 }, status: 400
    end
  end

  def show
    render json: { "message": 'show is called', "status": 200 }
  end

  def update
    render json: { "message": 'update is called', "status": 200 }
  end

  def delete
    render json: { "message": 'delete is called', "status": 200 }
  end

  # Strong params:
  # Ref: https://smartlogic.io/blog/permitting-nested-arrays-using-strong-params-in-rails/
  def course_params
    params.permit(
      :name,
      :lecturer,
      :description,
    # :chapters => []
    )
  end
end