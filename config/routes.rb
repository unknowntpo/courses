Rails.application.routes.draw do
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      get "/courses" => "courses#index", :as => :get_courses
      get "/courses/:course_id" => "courses#show", :as => :show_course
      post "/courses" => "courses#create", :as => :create_course
      patch "/courses/:course_id" => "courses#update", :as => :update_course
      delete "/courses/:course_id" => "courses#delete", :as => :delete_course

    end
  end

  # root "courses#index"
end
