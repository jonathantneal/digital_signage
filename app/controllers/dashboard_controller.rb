class DashboardController < ApplicationController

  before_filter :authenticate_user!
  filter_access_to :show

  def show
    @recent_slides = Slide.find(:all, :order => 'created_at DESC', :limit => 5)
    @expired_slides = Slide.expired_slides
    flash_announcements_for(current_user)
  end

end
