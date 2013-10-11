class PagesController < ApplicationController
  def home
  	respond_to do |format|
  		format.html { redirect_to '/games'} if user_signed_in?
  		format.html
  	end
  end

  def about
  end
  
end
