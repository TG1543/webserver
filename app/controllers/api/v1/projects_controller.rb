class Api::V1::ProjectsController <  ApplicationController
  before_action :authenticate_with_token!, only: [:index, :show, :create, :update]
  before_action :is_admin!, only: [:index, :create]
  before_action :is_main_investigator!, only: [:show, :update]

  before_action :is_authorized!, only: [:show, :update]
  before_action :is_canceled!, except: [:index,:show,:create]
  respond_to :json

  def show
    respond_with Project.where(id: params[:id]).first, include: :experiments #{experiments: { include: :iterations}}
  end

  def index
    #Arreglar esto para los investigadores
    respond_with Project.all
  end

  def create
    project = Project.new(project_params)
    if project.save
      render json: project, status: 201, location: [:api, project]
    else
      puts project.errors
      render json: { errors: project.errors }, status: 422
    end
  end

  def update
    project = Project.where(id: params[:id]).first
    if project && project.update(project_params)
      render json: project, status: 200, location: [:api, project]
    else
      render json: { errors: project.errors }, status: 422
    end
  end

  private
    def project_params
      params.require(:project).permit(:user_id, :name, :description, :state_id)
    end

    def is_authorized!
      if !current_user.is_admin?
        cors_control_headers
        render json: { errors: "Usuario sin autorización para editar" }, status: 422 if !current_user.projects.where(id: params[:id]).first
      end
    end

    def is_canceled!
      cors_control_headers
      render json: { errors: "El projecto está cancelado" }, status: 422 if Project.find(params[:id]).is_canceled?
      render json: { errors: "El projecto está finalizado" }, status: 422 if Project.find(params[:id]).is_finished?
    end

end
