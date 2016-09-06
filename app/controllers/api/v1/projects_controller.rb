class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :create, :update]
  before_action :is_admin!, only: [:index, :create]
  before_action :is_main_investigator!, only: [:show, :update]


  before_action :is_canceled!, except: [:index,:show,:create]
  respond_to :json

  def show
    respond_with get_user.projects.find(params[:id])
  end

  def index
    respond_with Project.all
  end

  def create
    project = get_user.projects.build(project_params)
    if project.save
      render json: project, status: 201, location: [:api, current_user, project]
    else
      render json: { errors: project.errors }, status: 422
    end
  end

  def update
    project = get_user.projects.find(params[:id])
    if project.update(project_params)
      render json: project, status: 200, location: [:api, current_user, project]
    else
      render json: { errors: project.errors }, status: 422
    end
  end

  private
    def project_params
      params.require(:project).permit(:user_id,:name, :description, :state_id)
    end

    def get_user
      user = current_user
      user = User.find(params[:user_id]) if current_user.is_admin?
      user
    end

    def is_canceled!
      render json: { errors: "La iteracion está cancelada" } if get_user.projects.find(params[:id]).is_canceled?
    end

end
