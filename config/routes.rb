Rails.application.routes.draw do
  # Explicitly define sign_out route before resources :users to avoid conflict
  devise_scope :user do
    get '/users/sign_out' => 'users/sessions#destroy'
  end

  # Devise authentication routes
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Root route
  root "tweets#index"

  # Tweet resources with nested comments and likes
  resources :tweets do
    collection do
      get :search
    end
    resources :comments, only: [:create, :destroy]
    resource :like, only: [:create, :destroy]
  end

  # User profiles and follow system
  resources :users, only: [:show, :index] do
    member do
      post :follow
      delete :unfollow
      get :followers
      get :following
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
