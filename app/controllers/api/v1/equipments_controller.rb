class Api::V1::EquipmentsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :is_laboratorist!

  respond_to :json

  def show
    respond_with Equipment.where(id: params[:id]).first
  end

  def index
      respond_with Equipment.all
  end

  def create
    equipment = Equipment.new(equipment_params)
    if equipment.save
      render json: equipment, status: 201, location: [:api, get_user, equipment]
    else
      render json: { errors: equipment.errors }, status: 422
    end
  end

  def update
    equipment = Equipment.find(params[:id])
    if equipment.update(project_params)
      render json: equipment, status: 200, location: [:api, get_user, equipment]
    else
      render json: { errors: equipment.errors }, status: 422
    end
  end

  def toggle_state
    equipment = Equipment.find(params[:id])
    equipment.active = !equipment.active
    if user.save
      render json: user, status: 200, location: [:api, get_user, equipment]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private
    def equipment_params
      params.require(:equipment).permit(:active,:name, :serial_number)
    end

    def get_user
      user = current_user
      user = User.find(params[:user_id]) if current_user.is_admin?
      user
    end

end
