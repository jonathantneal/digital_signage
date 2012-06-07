# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  before_filter :set_current_user

  include SslRequirement if defined? SslRequirement

  helper :all # include all helpers, all the time

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected

  def flash_announcements_for(user=nil)
    user ||= current_user
    Announcement.current.after(user.last_sign_in_at).each do |announcement|
      flash.now[:announce] = announcement.announcement
    end
  end
  
  def set_current_user
    Authorization.current_user = current_user
  end

  def permission_denied
    if user_signed_in?
      render :file => "#{Rails.root}/public/403", :formats => [:html], :status => 403, :layout => false
    else
      redirect_to new_user_session_url
    end
    
  end
  
end
