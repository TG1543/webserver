class BaseController < ActionController::Base

	before_action :cors_check
	after_action :cors_control_headers

	def cors_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
		headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
		headers['Access-Control-Max-Age'] = "1728000"
	end

	def cors_check
		if request.method == 'OPTIONS'
		  headers['Access-Control-Allow-Origin'] = '*'
		  headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
		  headers['Access-Control-Allow-Headers'] = 'X-Requested-With, Token, Content-Type, Authorization'
		  headers['Access-Control-Max-Age'] = '1728000'

		  render :text => '', :content_type => 'text/plain'
		end
	end
end
