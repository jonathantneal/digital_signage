class DashboardController < ApplicationController

  before_filter :authenticate_user!
  filter_access_to :show
  respond_to :html

  def show
    @recent_slides = Slide.order('created_at DESC').limit(5)
    @expired_slides = Slide.expired_slides
    @signs = Sign.with_permissions_to(:index)
    
    #flash_announcements_for(current_user)
  end

end
