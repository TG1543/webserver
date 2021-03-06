class Api::V1::IterationsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :is_investigator!
  before_action :is_authorized!
  before_action :is_canceled!, except: [:index,:show,:create]
  respond_to :json


  def index
    respond_with Experiment.find(params[:experiment_id]).iterations.all
  end

  def show
    respond_with get_iteration, include: [:binnacles,:equipment,:values]
  end

  def update
    iteration = get_iteration
    if iteration.update(iteration_params)
      render json: iteration, status: 200, location: [:api, iteration]
    else
      render json: { errors: iteration.errors || "La iteración está cancelada" }, status: 422
    end
  end

  def create
    iteration = Iteration.new(iteration_params)
    if iteration.save
      render json: iteration, status: 201, location: [:api, iteration]
    else
      render json: { errors: iteration.errors }, status: 422
    end
  end

  def add_comment
      iteration = get_iteration
      if iteration.add_comment(comment_params)
        render json: iteration, status: 201, location: [:api, iteration]
      else
        render json: { errors: iteration.errors }, status: 422
      end
  end

  def add_plot
      iteration = get_iteration
      if iteration.add_plot(plot_params)
        render json: iteration, status: 201, location: [:api, iteration]
      else
        render json: { errors: iteration.errors }, status: 422
      end
  end

  def assign_equipment
    equipment_id = params[:equipment][:equipment_id]
    iteration = get_iteration
    if iteration.assign_equipment(equipment_id)
        render json: iteration, status: 201, location: [:api, iteration]
    else
        render json: { errors: "No se asignó el equipo." }, status: 422
    end
  end

  def unassign_equipment
    iteration = get_iteration
    if iteration.unassign_equipment
        render json: iteration, status: 201, location: [:api, iteration]
    else
        render json: {  errors: "No se desasignó el equipo."}, status: 422
    end
  end

  def add_values_to_equipment
    iteration = get_iteration

    values = params[:values]
    if iteration.add_values_to_equipment(values)
        render json: iteration, status: 201, location: [:api,iteration]
    else
        render json: {  errors: "No se asignaron los valores de los parámetros al equipo."}, status: 422
    end
  end

  private
    def plot_params
      params.require(:plot).permit(:iterations_id,:name,:x_axis,:y_axis)
    end

    def comment_params
        params.require(:binnacle).permit(:comment,:date)
    end

    def iteration_params
      params.require(:iteration).permit(:experiment_id, :started_at, :ended_at, :state_id)
    end

    def get_iteration
      Iteration.where(id: params[:id]).first || Iteration.where(id: params[:iteration_id]).first
    end

    def get_experiment
      get_iteration.experiment
      experiment
    end

    def is_canceled!
      cors_control_headers
      render json: { errors: "La iteracion está cancelada" }, status: 422 if get_iteration.is_canceled?
      render json: { errors: "La iteracion está finalizada" }, status: 422 if get_iteration.is_finished?
    end

    def is_authorized!
      if !current_user.is_main_investigator?
        cors_control_headers
        experiment = get_experiment
        render json: { errors: "Usuario sin autorización." } if !(current_user.experiments.where(id: experiment.id).first ||
                                                  current_user.assigned_experiments.where(id: experiment.id).first)
      end
    end
end
