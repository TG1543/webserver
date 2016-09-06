class Api::V1::IterationsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :is_investigator!
  before_action :is_authorized!
  before_action :is_canceled!, except: [:index,:show,:create]
  respond_to :json


  def index
    respond_with get_experiment.iterations.all
  end

  def show
    respond_with get_iteration
  end

  def update
    iteration = get_iteration
    if iteration.update(iteration_params)
      render json: experiment, status: 200, location: [:api, current_user,get_experiment,iteration]
    else
      render json: { errors: experiment.errors || "El experimento está cancelado" }, status: 422
    end
  end

  def create
    iteration = get_experiment.iterations.build(iteration_params)
    if iteration.save
      render json: experiment, status: 201, location: [:api, current_user,get_experiment,iteration]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def add_comment
      iteration = get_iteration
      if iteration.add_comment(comment_params)
        render json: iteration, status: 201, location: [:api, current_user,get_experiment,iteration]
      else
        render json: { errors: iteration.errors }, status: 422
      end
  end

  def add_plot
      iteration = get_iteration
      if iteration.add_plot(plot_params)
        render json: iteration, status: 201, location: [:api, current_user,get_experiment,iteration]
      else
        render json: { errors: iteration.errors }, status: 422
      end
  end

  def assign_equipment
    equipment_id = params[:equipment][:equipment_id]
    iteration = get_iteration
    if iteration.assign_equipment(equipment_id)
        render json: iteration, status: 201, location: [:api, current_user,get_experiment,iteration]
    else
        render json: { errors: "No se asignó el equipo." }, status: 422
    end
  end

  def unassign_equipment
    iteration = get_iteration
    if iteration.unassign_equipment
        render json: iteration, status: 201, location: [:api, current_user,get_experiment,iteration]
    else
        render json: {  errors: "No se desasignó el equipo."}, status: 422
    end
  end

  def add_values_to_equipment
    iteration = get_iteration
    values = params[:values]
    if iteration.add_values_to_parameter(values)
        render json: iteration, status: 201, location: [:api, current_user,get_experiment,iteration]
    else
        render json: {  errors: "No se asignaron los valores de los parámetros al equipo."}, status: 422
    end
  end

  private
    def plot_params
      params.require(:binnacle).permit(:iterations_id,:name,:x_axis,:y_axis)
    end

    def comment_params
        params.require(:binnacle).permit(:comment,:date)
    end

    def iteration_params
      params.require(:iteration).permit(:experiment_id, :started_at, :ended_at, :state_id)
    end

    def get_iteration
      get_experiment.iterations.find(params[:id])
    end

    def get_experiment
      experiment = get_user.experiments.where(id: params[:experiment_id]).first
      experiment = get_user.assign_experiments.where(id: params[:experiment_id]).first unless experiment
      experiment
    end

    def get_user
      user = current_user
      user = User.find(params[:user_id]) if current_user.is_main_investigator?
      user
    end

    def is_canceled!
      render json: { errors: "La iteracion está cancelada" } if get_experiment.iterations.find(params[:id]).is_canceled?
    end

    def is_authorized!
      if !current_user.is_admin?
        render json: { errors: "Usuario sin autorización." } if (!current_user.experiments.where(id: params[:experiment_id]).first &&
                                                  !current_user.assign_experiments.where(id: params[:experiment_id]).first)
      end
    end
end
