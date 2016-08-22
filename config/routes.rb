require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  # Api definition
  namespace :api, defaults: { format: :json } do #, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:index, :show, :create, :update] do
        member do
          patch 'change_role' => 'users#change_role', as: :change_role
          patch 'toggle_state' => 'users#toggle_state', as: :toggle_state
        end
        resources :projects, :only => [:show, :update]
      end
      resources :projects, :only => [:index, :create]
      resources :sessions, :only => [:create, :destroy]
    end
  end
end
