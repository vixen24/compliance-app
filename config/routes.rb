Rails.application.routes.draw do
  resource :session, only: [ :new, :create, :destroy ] do
    scope module: :sessions do
      resource :magic_link
    end
  end
  get "/sign-in", to: "sessions#new", as: :sign_in
  delete "/sign-out", to: "sessions#destroy", as: :sign_out
  get "/sign-up", to: "sign_ups#new", as: :sign_up

  resource :sign_up, only: [ :new, :create ], path: "sign-up"
  resources :passwords, param: :token
  resources :accounts
  resource :current_team, only: [ :update ], controller: "current_team"

  resources :teams do
    resources :assessments do
      resources :answers, only: [ :create, :update ] do
        resources :feedbacks, only: [ :create, :index ]
      end
    end
    resource :dashboard, only: [ :show ], controller: "dashboard"
    resources :controls
    resources :users
  end

  namespace :executive do
    resource :subsidiary_dashboard, only: [ :show ], controller: "subsidiary_dashboard"
    resource :group_dashboard, only: [ :show ], controller: "group_dashboard"
    resources :users
  end

  namespace :admin do
    resource :dashboard, only: [ :show ], controller: "dashboard"
    resources :sessions, only: [ :index, :destroy ]
    resources :assessments, only: [ :index, :new, :create, :update, :destroy ]
    resources :users
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#show"
end
