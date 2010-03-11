class UserSessionsController < ApplicationController

  load_and_authorize_resource
  
  include SslRequirement
  ssl_required :new, :create

  protected
  def ssl_required?
    # only require HTTPS in non-development environments
    RAILS_ENV != 'development' && super
  end

  public
  def new
    @user_session = UserSession.new
    render :layout => 'login'
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_url
    else
      render :action => :new, :layout => 'login'
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to new_user_session_url
  end

end
