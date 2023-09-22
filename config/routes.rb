Rails.application.routes.draw do
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      get "/courses" => "courses#index", :as => :get_courses 
      get "/courses/:course_id" => "courses#get_by_id", :as => :get_course_by_id
      post "/courses" => "courses#create", :as => :create_course
      patch "/courses/:course_id" => "courses#update", :as => :update_course


      # TODO: update, delete chapter, unit

    end
  end

  root "courses#index"
end
