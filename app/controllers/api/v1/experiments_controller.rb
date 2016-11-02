class Api::V1::ExperimentsController < ApplicationController
  before_action :authenticate_with_token!, only: [ :show, :create, :update, :add_user_to_experiment]
  before_action :is_main_investigator!, only: [ :create, :add_user_to_experiment]
  before_action :is_investigator!, only: [:show, :update]

  before_action :is_authorized!, only: [:show, :update]
  before_action :is_canceled!, except: [:index, :show, :create]
  respond_to :json


  def show
    respond_with get_experiment, include: :iterations
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

  def add_user_to_experiment
      project = get_project
      if (current_user.is_admin? || project.user_id == current_user.id)
        experiment = get_experiment
        user_id = params[:user_id]
        if (experiment.users.where(user_experiments: {user_id: user_id}).size == 0)
          if experiment.add_user(user_id)
            render json: User.find(user_id), status: 201, location: [:api, experiment]
          else
            render json: { errors: experiment.errors }, status: 422
          end
        else
          render json: { errors: "Ya fue agregado el usuario al experimento" }, status: 422
        end
      else
          render json: { errors: "Usuario sin autorización." }, status: 422
      end
  end

  def remove_user_to_experiment
      project = get_project
      if (current_user.is_admin? || project.user_id == current_user.id)
        experiment = get_experiment
        user_id = params[:user_id]
        if experiment.remove_user(user_id)
          render json: User.find(user_id), status: 201, location: [:api, experiment]
        else
          render json: { errors: experiment.errors }, status: 422
        end
      else
          render json: { errors: "Usuario sin autorización." }, status: 422
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
      cors_control_headers
      render json: { errors: "El experimento está cancelado" }, status: 422 if get_experiment.is_canceled?
      render json: { errors: "El experimento está finalizado" }, status: 422 if get_experiment.is_finished?
    end

    def is_authorized!
      if !current_user.is_main_investigator?
        cors_control_headers
        experiment = get_experiment
        render json: { errors: "Usuario sin autorización." }, status: 422 if !(current_user.experiments.where(id: params[:id]).first ||
                                                current_user.assign_experiments.where(id: params[:id]).first)
      end
    end



end
