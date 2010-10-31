class UsersController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access

  # GET /users
  def index

    @search = User.with_permissions_to(:index).search(params[:search])
    @users = @search.paginate(:page => params[:page])

    @user = User.new

    respond_to do |format|
      format.html # index.html.haml
      format.js { render :partial => 'users' }
    end

  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
  end

  # POST /users
  def create
    if @user.save
      flash[:notice] = 'User created'
      redirect_to(@user)
    else
      render :action => 'new'
    end
  end

  # GET /users/1/auto_update
  def auto_update
  
    # @user.update_from_directory should be triggered automatically
    
    if @user.save
      flash[:notice] = 'User updated'
    end
    redirect_to(@user)
    
  end

  # DELETE /users/1
  def destroy
    if @user.destroy
      flash[:notice] = 'User deleted'
    end
    redirect_to(users_url)
  end
  
end
