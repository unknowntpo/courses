class Api::V1::CoursesController < ApiController
  def index
    # https://guides.rubyonrails.org/active_record_basics.html#read
    @courses = Course.all

    # https://guides.rubyonrails.org/layouts_and_rendering.html#rendering-json
    render json: @courses
  end

  def create
    # FIXME: course, chapter, unit should be created simultaneously  
    logger.info "got params: #{params.inspect}"
    @course = Course.new(:name => params[:name],
     :lecturer => params[:lecturer],
      :description => params[:description])

    logger.info "new course are newed: #{@course.inspect}"
    
    if @course.save
      render json: @course
    else
      render json: {:message => "failed to create new course", :status => 400} 
    end
  end

  def show
    @course = Course.find_by(params[:id])

    render json: @course
  end

  def update
    @course = Course.find_by(params[:id])
    # logger.info "try to update #{@course}"
    logger.info "try to udpate #{@course}"


    render json: @course
  end

  def delete
    @course = Course.find_by(params[:id])
    # logger.info "try to update #{@course}"
    logger.info "try to delete #{@course}"

    render json: @course
  end
end