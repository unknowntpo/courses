class Api::V1::CoursesController < ApplicationController

  def index
    @courses = Course.get_all
    render json: @courses
  end

  def create
    render json: {"message": 'create is called', "status": 200}
  end

  def show
    render json: {"message": 'show is called', "status": 200}
  end

  def update
    render json: {"message": 'update is called', "status": 200}
  end
  def delete
    render json: {"message": 'delete is called', "status": 200}
  end
end