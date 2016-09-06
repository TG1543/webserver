class Api::V1::ExperimentsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :create, :update, :add_user_to_experiment]
  before_action :is_main_investigator!, only: [:index, :create, :add_user_to_experiment]
  before_action :is_authorized!, only: [:index, :create, :add_user_to_experiment]
  before_action :is_investigator!, only: [:show, :update]
  before_action :is_canceled!, except: [:index,:show,:create]
  respond_to :json

  def index
    respond_with get_project.experiments.all
  end

  def show
    respond_with get_project.experiments.where(id: params[:id]).first
  end

  def update
    experiment = get_project.experiments.find(params[:id])
    if experiment.update(experiment_params)
      render json: experiment, status: 200, location: [:api, get_user,get_project, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def create
    experiment = get_project.experiments.build(experiment_params)
    if experiment.save
      render json: experiment, status: 201, location: [:api, get_user,get_project, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def add_users_to_experiment
      experiment = get_experiment
      #TODO: Obtener usuarios
      if experiment.add_users(users)
        render json: experiment.users, status: 201, location: [:api, get_user,get_project, experiment]
      else
        render json: { errors: experiment.errors }, status: 422
      end
  end

  private
    def experiment_params
      params.require(:experiment).permit(:description, :state_id, :result_id)
    end

    def get_project
      get_user.projects.find(params[:project_id])
    end

    def get_experiment
       experiment = get_user.experiments.where(id: params[:id]).first
       experiment = get_user.assign_experiments.where(id: params[:id]).first unless experiment
       experiment
    end

    def get_user
      user = current_user
      user = User.find(params[:user_id]) if current_user.is_main_investigator?
      user
    end

    def is_canceled!
      render json: { errors: "El experimento está cancelada" } if get_experiment.is_canceled?
    end

    def is_authorized!
        if !current_user.is_admin?
          render json: { errors: "Usuario sin autorización." } if !current_user.projects.where(id: params[:project_id]).first
        end
    end

end
