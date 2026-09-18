Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise routes for user authentication
  devise_for :users

  # Dynamic routing for authenticated users vs guest visitors
  authenticated :user do
    root to: "expenses#index", as: :authenticated_root
  end

  # Public home landing page for guests
  root to: "home#index"

  # Resourceful expenses management
  resources :expenses
end
