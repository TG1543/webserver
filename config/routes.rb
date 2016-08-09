require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json } do #, constraints: { subdomain: 'api' }, path: '/' do

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
       resources :users, :only => [:show, :create, :update, :destroy] do
         resources :projects, :only => [:create]
       end
       resources :sessions, :only => [:create, :destroy]
       resources :projects, :only => [:index, :show]
    end
  end
end
