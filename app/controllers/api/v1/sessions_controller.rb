class Api::V1::SessionsController < ApplicationController
  def create
   user_password = params[:sessions][:password]
   user_email = params[:sessions][:email]
   user = user_email.present? && User.find_by(email: user_email)

   if user.valid_password? user_password
     sign_in user, store: false
     user.generate_authentication_token!
     user.save
     render json: user, status: 200, location: [:api, user]
   else
     render json: { errors: "Invalid email or password" }, status: 422
   end
 end
end
