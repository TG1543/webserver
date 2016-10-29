class ApplicationController < BaseController
  protect_from_forgery with: :null_session
  include Authenticable
end
