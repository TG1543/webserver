require 'api_constraints'

Rails.application.routes.draw do
  get '/' => 'static_pages#index'

  devise_for :users, :controllers => { registrations: 'registrations' }

  # Api definition
  namespace :api, defaults: { format: :json } do #, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :users, :only => [:index, :show, :create, :update] do
        member do
          patch 'change_role' => 'users#change_role', as: :change_role
          patch 'toggle_state' => 'users#toggle_state', as: :toggle_state
        end
      end

      resources :projects, :only => [:index, :show, :create, :update] do
      end

      resources :experiments, :only => [:show,:update,:create] do
        member do
          patch 'add_users_to_experiment' => 'experiments#add_users_to_experiment', as: :add_users_to_experiment
        end
      end
      get 'experiments/index/:project_id' => 'experiments#index', as: :index

      resources :iterations, :only =>[:show,:update,:create] do
        member do
          post 'add_comment' => 'iterations#add_comment', as: :add_comment
          post 'add_plot' => 'iterations#add_plot', as: :add_plot
          post 'add_values_to_equipment' => 'iterations#add_values_to_equipment', as: :add_values_to_equipment
          post 'assign_equipment' => 'iterations#assign_equipment', as: :assign_equipment
          post 'unassign_equipment' => 'iterations#unassign_equipment', as: :unassign_equipment
        end
      end
      get 'iterations/index/:experiment_id' => 'iterations#index', as: :index

      resources :equipments, :only => [:index, :show,:update,:create] do
        member do
          patch 'toggle_state' => 'equipments#toggle_state', as: :toggle_state
        end
      end

      resources :sessions, :only => [:create, :destroy]

    end
  end
end
