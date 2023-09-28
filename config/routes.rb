Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api, :defaults => {:format => :json} do
    namespace :v1 do
      get "/courses" => "courses#index", :as => :get_courses
      get "/courses/:course_id" => "courses#show", :as => :show_course
      post "/courses" => "courses#create", :as => :create_course
      patch "/courses/:course_id" => "courses#update", :as => :update_course
      delete "/courses/:course_id" => "courses#delete", :as => :delete_course

    end
  end

  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: 'graphql#execute' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'

  # root "courses#index"
end
