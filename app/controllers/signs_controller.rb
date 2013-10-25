class SignsController < ApplicationController
  filter_resource_access additional_member: [:check_in, :display, :drop_on]
  respond_to :html, except: :check_in
  respond_to :json, only: [:show, :check_in]

  def index
    @signs = Sign.with_permissions_to(:index).order('signs.title')
    @sign = Sign.new
  end

  def show
    if request.format.json?
      render json: @sign
    elsif user_logged_in?
      @q = @sign.slots.search(params[:q])
      @slots = @q.result(distinct: true).published_status(params[:published_status]).includes(slide: :schedules)

      # Initialize new slide for mini form
      @slide = Slide.new
      @slide.signs << @sign

      respond_with(@slides) do |format|
        format.js do
          render :partial => 'slots' unless params["_"] # Otherwise if infinites scroll render index.js.erb
        end
      end
    else
      permission_denied
    end
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
    if @sign.update_attributes(sign_params)
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
    render :json => { result: 'success' }
  end

  def display
    render :layout => false
  end

  def drop_on
    slide = Slide.from_drop params[:file], @sign.department

    if slide.save
      @sign.slides << slide
      flash[:notice] = "Slide has been added"
      render :json => { result: 'success' }
    else
      flash[:danger] = "There was a problem adding the slide"
      render :json => { result: 'error' }
    end
  end

  protected

    # Used by Declarative Authorization
    def load_sign
      @sign = Sign.where('id = ? OR name = ?', params[:id], params[:id]).first
    end

    # Override DeclarativeAuthorization method
    def new_sign_from_params
      if params[:sign]
        @sign = Sign.new(sign_params)
      else
        @sign = Sign.new
      end
    end

    # Only allow a trusted parameter "white list" through.
    def sign_params
      params.require(:sign).permit(:name, :title, :reload_interval, :check_in_interval, :department_id, :email, :width, :height)

      # schedule:  attr_accessible :slide, :when, :active
    end
end