class ApplicationController < BaseController
  protect_from_forgery with: :null_session, if: ->{request.format.json?}
  include Authenticable
end
