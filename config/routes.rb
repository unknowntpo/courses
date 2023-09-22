Rails.application.routes.draw do
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      get "/courses" => "courses#index", :as => :courses 
      get "/courses/:course_id" => "courses#get_by_id", :as => :course
      post "/courses" => "courses#create", :as => :create_courses

      # TODO: update, delete chapter, unit

    end
  end

  root "courses#index"

# + namespace :api, :defaults => { :format => :json } do
# +   namespace :v1 do
# +     get "/trains"  => "trains#index", :as => :trains
# +     get "/trains/:train_number" => "trains#show", :as => :train
# +
# +     get "/reservations/:booking_code" => "reservations#show", :as => :reservation
# +     post "/reservations" => "reservations#create", :as => :create_reservations
# +     patch "/reservations/:booking_code" => "reservations#update", :as => :update_reservation
# +     delete "/reservations/:booking_code" => "reservations#destroy", :as => :cancel_reservation
# +   end
# + end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
