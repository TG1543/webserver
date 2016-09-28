class Api::V1::ExperimentsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :create, :update, :add_user_to_experiment]
  before_action :is_main_investigator!, only: [:index, :create, :add_user_to_experiment]
  before_action :is_investigator!, only: [:show, :update]

  before_action :is_authorized!, only: [:show, :update]
  before_action :is_canceled!, except: [:index, :show, :create]
  respond_to :json

  def index
    respond_with Project.find(id: params[:project_id]).experiments.all
  end

  def show
    respond_with get_experiment
  end

  def update
    experiment = get_experiment
    if experiment.update(experiment_params)
      render json: experiment, status: 200, location: [:api, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def create
    experiment = Experiment.new(experiment_params)
    if experiment.save
      render json: experiment, status: 201, location: [:api, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def add_users_to_experiment
      project = get_project
      if (current_user.is_admin? || project.user_id == current_user.id)
        experiment = get_experiment
        #TODO: Obtener usuarios
        if experiment.add_users(users)
          render json: experiment.users, status: 201, location: [:api, experiment]
        else
          render json: { errors: experiment.errors }, status: 422
        end
      else
          render json: { errors: "Usuario sin autorización." }
      end
  end

  private
    def experiment_params
      params.require(:experiment).permit(:project_id, :description, :state_id, :result_id)
    end

    def get_project
      experiment = get_experiment
      experiment.project if experiment
    end

    def get_experiment
       Experiment.where(id: params[:id]).first
    end

    def is_canceled!
      render json: { errors: "El experimento está cancelada" } if get_experiment.is_canceled?
    end

    def is_authorized!
      if !current_user.is_main_investigator?
        experiment = get_experiment
        render json: { errors: "Usuario sin autorización." } if !(current_user.experiments.where(id: params[:id]).first ||
                                                current_user.assign_experiments.where(id: params[:id]).first)
      end
    end

end
