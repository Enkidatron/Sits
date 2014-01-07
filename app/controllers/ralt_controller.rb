class RaltController < ApplicationController
	def show
		@ralt = Ralt.new(params[:f],params[:t],params[:d])
	end
end
