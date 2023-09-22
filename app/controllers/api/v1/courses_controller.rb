class Api::V1::CoursesController < ApiController
  def index
    @courses = Course.all
    render :json => {
      :data => @courses.map{ |course|
        {
          :name => @course.name,
          :lecturer => @course.lecturer
        }
      }
    }
  end

  def show
    @course = Course.find_by_number!( params[:id] )

    render :json => {
      :id => @course.id,
      :name => @course.number,
      :lecturer => @course.lecturer
    }
  end
end
