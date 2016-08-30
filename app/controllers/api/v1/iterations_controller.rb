class Api::V1::IterationsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :create, :update,:add_comment]
  before_action :is_investigator!

  def index
    respond_with get_experiment.iterations.all
  end

  def show
    respond_with get_experiment.iterations.find(params[:id])
  end

  def update
    experiment = get_experiment.iterations.find(params[:id])
    if experiment.update(experiment_params)
      render json: experiment, status: 200, location: [:api, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def create
    experiment = get_project.experiments.build(experiment_params)
    if experiment.save
      render json: experiment, status: 201, location: [:api, experiment]
    else
      render json: { errors: experiment.errors }, status: 422
    end
  end

  def add_comment
      iteration = get_experiment.iterations.find(params[:id])
      if iteration.add_comment(comment_params)
        render json: iteration, status: 201, location: [:api, iteration]
      else
        render json: { errors: iteration.errors }, status: 422
      end
  end

  private
    def comment_params
        params.require(:binnacle).permit(:comment,:date)
    end
    def iteration_params
      params.require(:iteration).permit(:experiment_id, :started_at, :ended_at)
    end

    def get_experiment
      get_user.experiment.find(params[:experiment_id])
    end

    def get_user
      user = current_user
      user = User.find(params[:user_id]) if current_user.is_main_investigator?
      user
    end
end
