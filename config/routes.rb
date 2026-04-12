Rails.application.routes.draw do
  get "/signin", to: "sessions#new", as: :sign_in
  delete "/signout", to: "sessions#destroy", as: :sign_out
  resource :session, only: [ :new, :create, :destroy ] do
    scope module: :sessions do
      resource :magic_link
    end
  end

  resource :sign_up, only: [ :new, :create ]
  get "/signup", to: "sign_ups#new"

  resources :accounts
  resources :passwords, param: :token
  resource :current_team, only: [ :update ], controller: "current_team"

  resources :teams do
    resources :assessments do
      resources :answers, only: [ :create, :update ]
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
    resource :setting, only: [ :show, :update ], controller: "setting"
    resources :sessions, only: [ :index, :destroy ] do
      delete :destroy, on: :collection
    end
    resources :assessments, only: [ :index, :new, :create, :update, :destroy ]
    resources :users
    mount MissionControl::Jobs::Engine, at: "/jobs", as: "mission_control_jobs"
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root "home#show"
end
