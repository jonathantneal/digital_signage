class DashboardController < ApplicationController

  # If they can't see a slide they shouldn't be able to see the dashboard
  authorize_resource(:class=>Slide)

  def show
    @recent_slides = Slide.find(:all, :order => 'created_at DESC', :limit => 5)
  end

end
