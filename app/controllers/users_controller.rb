class UsersController < ApplicationController

  load_and_authorize_resource

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
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

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User updated'
      redirect_to(@user)
    else
      render :action => 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    if @user.destroy
      flash[:notice] = 'User deleted'
    end
    redirect_to(users_url)
  end
  
end
