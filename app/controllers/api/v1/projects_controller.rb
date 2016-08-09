class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_with_token!, only: [:create]
  respond_to :json

 def show
   respond_with Project.find(params[:id])
 end

 def index

    respond_with Project.all
  end

  def create
    project = current_user.projects.build(project_params)
    if project.save
      render json: project, status: 201, location: [:api, project]
    else
      render json: { errors: project.errors }, status: 422
    end
  end

  private

    def project_params
      params.require(:project).permit(:name, :description)
    end
end
