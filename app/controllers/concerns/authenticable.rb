  module Authenticable
  # before filter para utilizar con request de tipo jason
  # Devise methods overwrites
  #TODO: generar token nuevo para mas seguridad
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
    #@current_user = warden.user if @current_user == nil
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

end
