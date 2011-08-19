class SignsController < ApplicationController

  before_filter :authenticate_user!, :except=>[:show, :check_in]
  filter_resource_access :additional_member => :check_in
  respond_to :html, :except => :check_in
  respond_to :xml, :only => [:show, :check_in]

  def index
    @signs = Sign.with_permissions_to(:index)
  end

  def show
    if user_signed_in? || request.format.xml?
      respond_with @sign
    else
      authenticate_user!
    end
  end

  def new
  end

  def edit
  end

  def create
    if @sign.save
      flash[:notice] = 'Sign created'
    end
    respond_with @sign
  end

  def update
    if @sign.update_attributes(params[:sign])
      flash[:notice] = 'Sign updated'
    end
    respond_with @sign
  end

  def destroy
    if @sign.destroy
      flash[:notice] = 'Sign deleted'
    end
    respond_with @sign
  end
  
  def check_in
    @sign = Sign.find_by_id(params[:id]) || Sign.find_by_name(params[:id])
    @sign.last_check_in = DateTime.now
    # This is a hack to get around this issue: https://github.com/rails/rails/issues/1010
    @sign.last_ip = request.headers['HTTP_X_FORWARDED_FOR'].to_s.strip.split(/[,\s+]/).first || request.remote_ip
    @sign.save(:validate => false)
    render :nothing => true
  end
  
  protected
  
  def load_sign
    @sign = Sign.where('id = ? OR name = ?', params[:id], params[:id]).first
    raise RecordNotFound if @sign.nil?
  end
  
end
