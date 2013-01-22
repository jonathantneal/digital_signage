class UsersController < ApplicationController

  filter_resource_access
  respond_to :html
  respond_to :js, :only=>:index

  def index
    @search = User.with_permissions_to(:index).metasearch(params[:search])
    @users = @search.relation.page(params[:page])
    @user = User.new
    # respond_with @users
    respond_to do |format|
      format.html # index.html.haml
      format.js { render :partial => 'users' }
    end
  end

  def show
  end

  def new
  end
  
  def edit
  end

  def create
    if @user.save
      flash[:notice] = 'User created'
    end
    respond_with @user
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User updated'
    end
    respond_with @user
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'User deleted'
    end
    respond_with @user
  end
  
end
