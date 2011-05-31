class UsersController < ApplicationController

  filter_resource_access
  respond_to :html
  respond_to :js, :only=>:index

  def index
    @search = User.with_permissions_to(:index).metasearch(params[:search])
    @users = @search.relation.page(params[:page])
    @user = User.new
    respond_with @users
  end

  def show
  end

  def new
  end

  def create
    if @user.save
      flash[:notice] = 'User created'
    end
    respond_with @user
  end

  def auto_update
    # @user.update_from_directory should be triggered automatically
    if @user.save
      flash[:notice] = 'User updated'
    end
    redirect_to @user # TODO change to post and use respond_with
  end

  def destroy
    if @user.destroy
      flash[:notice] = 'User deleted'
    end
    respond_with @user
  end
  
end
