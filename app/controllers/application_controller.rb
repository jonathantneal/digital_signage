class ApplicationController < ActionController::Base
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper :all # include all helpers, all the time
  helper_method :current_user, :user_logged_in?

  before_filter :set_current_user, :find_user_signs, :force_http

  protected

  def force_http
    if request.ssl? && (Rails.env.production? || Rails.env.staging?)
      redirect_to params.merge(protocol: 'http://'), status: :moved_permanently
    end
  end

  def set_current_user
    Authorization.current_user = current_user
  end

  def find_user_signs
    # Eventually I want to sort by most used
    if current_user
      @current_user_signs = current_user.signs.limit(10)
    end
  end

  def current_user
    return @current_user unless @current_user.nil?

    username = session[:username] || session['cas'].try(:[], 'user')
    cas_attrs = session['cas'].try(:[], 'extra_attributes') || {}

    return nil if username.nil?

    # @current_user = User.find_by_username(username) # || User.new(username: username)
    @current_user = User.where(username: username).first_or_initialize

    @current_user.tap do |user|
      if !session[:username] # first time returning from CAS
        user.update_from_cas! cas_attrs unless Rails.env.test?
        user.update_login_info!
      end

      if user.new_record?
        user = nil
      else
        session[:username] = user.username
      end
    end
  end
  impersonates :user  # must be defined after current_user

  def user_logged_in?
    current_user.present?
  end

  def permission_denied
    render_error_page(user_logged_in? ? 403 : 401)
  end

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end
end