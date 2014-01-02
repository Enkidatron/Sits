class BearingsController < ApplicationController
  def index
  end

  # GET /bearings
  def show
  	unless params[:f].nil? or params[:t].nil?
  		@bearing = Bearing.new(params[:f],params[:t],params[:s])
  	end
  end
end
