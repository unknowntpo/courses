class Api::V1::CoursesController < ApiController
  def index
    # https://guides.rubyonrails.org/active_record_basics.html#read
    @courses = Course.all

    # https://guides.rubyonrails.org/layouts_and_rendering.html#rendering-json
    render json: @courses
  end

  def get_by_id
    @course = Course.find_by(params[:id])

    render json: @course
  end
end
