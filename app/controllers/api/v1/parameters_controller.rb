class Api::V1::ParametersController < ApplicationController
  before_action :authenticate_with_token!
  before_action :is_investigator!
  respond_to :json

  def index
    respond_with Parameter.joins(:values).where(values: {iteration_id: params[:iteration_id]}).select(:id,:name,:quantity)
  end

end
