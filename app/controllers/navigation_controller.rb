class NavigationController < ApplicationController
	include NavigationHelper

  def loose
  	@nav = LooseNavigation.new(params[:s],params[:m],params[:e],params[:p],params[:r])
  end

  def strict
  	@nav = StrictNavigation.new(params[:s],params[:m],params[:e],params[:p],params[:r])
  end

  def top
  	@front = params[:f]
  	@tops = get_adjusted_window_chart(params[:f])[3] & get_adjusted_window_chart(invert_bearing(params[:f]))[3] if validate_bearing(params[:f])
  end
end
