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
      render json: equipment, status: 201, location: [:api, equipment]
    else
      render json: { errors: equipment.errors }, status: 422
    end
  end

  def update
    equipment = get_equipment
    if equipment.update(project_params)
      render json: equipment, status: 200, location: [:api, equipment]
    else
      render json: { errors: equipment.errors }, status: 422
    end
  end

  def toggle_state
    equipment = get_equipment
    equipment.active = !equipment.active
    if user.save
      render json: user, status: 200, location: [:api, equipment]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private
    def equipment_params
      params.require(:equipment).permit(:active,:name, :serial_number)
    end

    def get_equipment
      Equipment.find(params[:id])
    end

end
