  module Authenticable
  # before filter para utilizar con request de tipo jason
  # Devise methods overwrites
  #TODO: generar token nuevo para mas seguridad
  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
    #@current_user = warden.user if @current_user == nil
  end

  def authenticate_with_token!
    if !user_signed_in?
      render json: { errors: "No está autenticado." },status: :unauthorized
    else
      render json: { errors: "Usuario no está activo." } unless current_user && current_user.is_active?
    end
  end

  def user_signed_in?
    current_user.present?
  end


#methods for authorization
  def is_admin!
    render json: { errors: "Usuario sin autorización." } if !current_user.is_admin?
  end

  def is_main_investigator!
    render json: { errors: "Usuario sin autorización." } if !current_user.is_main_investigator?
  end

  def is_investigator!
    render json: { errors: "Usuario sin autorización." } if !current_user.is_investigator?
  end

  def is_laboratorist!
    render json: { errors: "Usuario sin autorización." } if !current_user.is_laboratorist?
  end

end
