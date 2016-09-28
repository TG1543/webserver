class Api::V1::BaseController < ApplicationController
  skip_before_filter :verify_authenticity_token

	before_filter :cors_check
	after_filter :cors_control_headers

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
		  headers['Access-Control-Allow-Headers'] = 'X-Requested-With, Token, Content-Type'
		  headers['Access-Control-Max-Age'] = '1728000'

		  render :text => '', :content_type => 'text/plain'
		end
	end
end
