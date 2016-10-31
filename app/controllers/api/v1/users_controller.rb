class Api::V1::UsersController < ApplicationController
   before_action :authenticate_with_token!, only: [:index, :show, :update, :destroy,:change_role,:toggle_state, :project_leaders]
   before_action :is_admin!, only: [:index,:change_role,:toggle_state,:project_leaders]
   respond_to :json

  def index
     respond_with User.all
  end

  def project_leaders
    respond_with User.where.not(role_id: 3).where.not(role_id: 4).where.not(role_id: 5)
  end

  def show
    respond_with get_user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = get_user
    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    get_user.destroy
    head 204
  end

  def change_role
    user = get_user
    user.role_id = params[:role_id]
    if user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def toggle_state
    user = get_user
    user.active = params[:active]
    if user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end


  private
    def user_params
      params.require(:user).permit(:name, :active, :role_id, :email, :password, :password_confirmation)
    end

    def get_user
      user = current_user
      user = User.find_by(id: params[:id]) if current_user.is_admin?
      user
    end

end
