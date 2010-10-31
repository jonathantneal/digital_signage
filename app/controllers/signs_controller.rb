class SignsController < ApplicationController

  before_filter :authenticate_user!, :except=>[:show, :check_in]
  filter_access_to :index, :new, :edit, :create, :update, :destroy

  # GET /signs
  def index
    @signs = Sign.all
  end

  # GET /signs/1
  # GET /signs/1.xml
  def show
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # GET /signs/new
  def new
    @sign = Sign.new
  end

  # GET /signs/1/edit
  def edit
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
  end

  # POST /signs
  def create
    @sign = Sign.new(params[:sign])
    if @sign.save
      flash[:notice] = 'Sign created'
      redirect_to(@sign)
    else
      render :action => 'new'
    end
  end

  # PUT /signs/1
  def update
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
    if @sign.update_attributes(params[:sign])
      flash[:notice] = 'Sign updated'
      redirect_to(@sign)
    else
      render :action => 'edit'
    end
  end

  # DELETE /signs/1
  def destroy
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
    if @sign.destroy
      flash[:notice] = 'Sign deleted'
    end
    redirect_to(signs_url)
  end
  
  # GET /signs/1/check_in
  def check_in
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
    @sign.last_check_in = DateTime.now
    @sign.last_ip = request.remote_ip
    @sign.save(false)
    respond_to do |format|
      format.xml
    end
  end
  
end
