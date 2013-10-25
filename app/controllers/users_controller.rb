class UsersController < ApplicationController

  filter_resource_access
  respond_to :html
  respond_to :js, :only=>:index

  def index
    @q = User.with_permissions_to(:index).search(params[:q])
    @users = @q.result(distinct: true).custom_search(params[:cs]).page(params[:page])

    # create new user for dropdown form
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
    if @user.update_attributes(user_params)
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

  private

    # Override DeclarativeAuthorization method
    def new_user_from_params
      if params[:user]
        @user = User.new(user_params)
      else
        @user = User.new
      end
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, department_ids: [])
    end
end
