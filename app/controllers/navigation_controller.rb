class NavigationController < ApplicationController
  def loose
  	@nav = LooseNavigation.new(params[:s],params[:m],params[:e],params[:p],params[:r])
  end

  def strict
  	@nav = StrictNavigation.new(params[:s],params[:m],params[:e],params[:p],params[:r])
  end
end
