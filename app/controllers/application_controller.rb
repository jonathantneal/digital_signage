# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_current_user

  helper :all # include all helpers, all the time
  helper_method :current_user, :user_signed_in?

  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  protected

  def set_current_user
    Authorization.current_user = current_user
  end

  def current_user
    return @current_user unless @current_user.nil?

    username = session[:username] || session['cas'].try(:[], 'user')

    return nil if username.nil?

    @current_user = User.find_or_initialize_by_username(username)
    if !session[:username] # first time returning from CAS
      @current_user.cas_extra_attributes = session['cas'].try(:[], 'extra_attributes')
      @current_user.last_sign_in_at = @current_user.current_sign_in_at
      @current_user.last_sign_in_ip = @current_user.current_sign_in_ip
      @current_user.current_sign_in_at = Time.now
      @current_user.current_sign_in_ip = request.remote_ip
      @current_user.sign_in_count = @current_user.sign_in_count.to_i + 1
      @current_user.save
    end

    if @current_user.new_record?
      @current_user = nil
    else
      session[:username] = @current_user.username
    end

    @current_user
  end

  def user_signed_in?
    current_user.present?
  end

  def permission_denied
    render_error_page(user_signed_in? ? 403 : 401)
  end

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end
end