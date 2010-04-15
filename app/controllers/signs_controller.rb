class SignsController < ApplicationController

  load_and_authorize_resource

  # GET /signs
  def index
    @signs = Sign.all
  end

  # GET /signs/1
  # GET /signs/1.xml
  def show
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # GET /signs/new
  def new
  end

  # GET /signs/1/edit
  def edit
  end

  # POST /signs
  def create
    if @sign.save
      flash[:notice] = 'Sign created'
      redirect_to(@sign)
    else
      render :action => 'new'
    end
  end

  # PUT /signs/1
  def update
    if @sign.update_attributes(params[:sign])
      flash[:notice] = 'Sign updated'
      redirect_to(@sign)
    else
      render :action => 'edit'
    end
  end

  # DELETE /signs/1
  def destroy
    if @sign.destroy
      flash[:notice] = 'Sign deleted'
    end
    redirect_to(signs_url)
  end
  
  # GET /signs/1/checkin
  def check_in
    @sign.last_check_in = DateTime.now
    @sign.save
    respond_to do |format|
      format.xml
    end
  end
  
end
