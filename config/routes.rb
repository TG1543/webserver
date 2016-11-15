require 'api_constraints'

Rails.application.routes.draw do
  get '/' => 'static_pages#index'

  devise_for :users, :controllers => { registrations: 'registrations' }

  # Api definition
  namespace :api, defaults: { format: :json } do #, constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      controller :users, path: '/users' do
        match '/project_leaders', to: 'users#project_leaders', via: [:get, :options], as: :users_project_leaders
        match '/researchers', to: 'users#researchers', via: [:get, :options], as: :researchers
        match '/users_by_experiment/:experiment_id', to: 'users#users_by_experiment', via: [:get, :options], as: :users_by_experiment
      end

      controller :projects, path: '/projects' do
        match '/', to: 'projects#index', via: [:get, :options], as: :projects_index
        match '/',to: 'projects#create', via: [:post, :options], as: :project_create
        match '/:id',to: 'projects#update', via: [:patch, :options], as: :project_update
        match '/:id',to: 'projects#show', via: [:get, :options], as: :project
      end

      controller :experiments, path: '/experiments' do
        match '/assigned_experiments',to: 'experiments#assigned_experiments', via: [:get, :options], as: :assigned_experiments
        match '/',to: 'experiments#create', via: [:post, :options], as: :experiment_create
        match '/:id',to: 'experiments#update', via: [:patch, :options], as: :experiment_update
        match '/:id',to: 'experiments#show', via: [:get, :options], as: :experiment
        match '/:id/add_user_to_experiment',to: 'experiments#add_user_to_experiment', via: [:post, :options], as: :add_user_to_experiment
        match '/:id/remove_user_to_experiment',to: 'experiments#remove_user_to_experiment', via: [:post, :options], as: :remove_user_to_experiment
      end

      controller :sessions, path: '/sessions' do
        match '/', to: 'sessions#create', via: [:post, :options], as: :sessions_create
        match '/:id',to: 'sessions#destroy', via: [:delete, :options], as: :session_destroy
      end

      controller :iterations, path: '/iterations' do
        match '/add_comment',to: 'iterations#add_comment', via: [:post, :options], as: :iteration_add_comment
        match '/',to: 'iterations#create', via: [:post, :options], as: :iteration_create
        match '/:id',to: 'iterations#update', via: [:patch, :options], as: :iteration_update
        match '/:id',to: 'iterations#show', via: [:get, :options], as: :iteration
      end

      controller :equipments, path: '/equipments' do
        match '/', to: 'equipments#index', via: [:get, :options], as: :equipments_index
        match '/',to: 'equipments#create', via: [:post, :options], as: :equipments_create
        match '/:id',to: 'equipments#update', via: [:patch, :options], as: :equipments_update
        match '/:id',to: 'equipments#show', via: [:get, :options], as: :equipment
        match '/:id/toggle_state',to: 'equipments#toggle_state', via: [:patch, :options], as: :equipment_toggle_state
      end

      resources :iterations, :only =>[] do
        member do
          post 'add_plot' => 'iterations#add_plot', as: :add_plot
          post 'add_values_to_equipment' => 'iterations#add_values_to_equipment', as: :add_values_to_equipment
          post 'assign_equipment' => 'iterations#assign_equipment', as: :assign_equipment
          post 'unassign_equipment' => 'iterations#unassign_equipment', as: :unassign_equipment
        end
      end

      resources :users, :only => [:index,:show, :create, :update] do
        member do
          patch 'change_role' => 'users#change_role', as: :change_role
          patch 'toggle_state' => 'users#toggle_state', as: :toggle_state
        end
      end

      get 'iterations/index/:experiment_id' => 'iterations#index', as: :iterations_index

    end
  end
end
