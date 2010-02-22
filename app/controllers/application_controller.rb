# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  # include all helpers, all the time
  helper :all

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  # PLUGIN: declarative_authorization
  # before_filter { |c| Authorization.current_user = c.current_user }
  
  # turns off layouts for ajax requests. 
  # taken from http://artofmission.com/articles/2006/12/20/turn-off-rails-layouts-for-ajax-requests
  layout proc{ |c| c.request.xhr? ? false : "application" } 
  
  protected
  
  def permission_denied
    flash[:error] = "You are not allowed to access that page."
    redirect_to root_url
  end
  
end
