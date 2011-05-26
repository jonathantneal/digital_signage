class SlidesController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access
  respond_to :html
  respond_to :js, :only => :index

  def index
    @search = Slide.search(params[:search])
    @slides, @slides_count = @search.all.paginate(:page=>params[:page], :per_page=>10), @search.count
    respond_with(@slides) do |format|
      format.js { render :partial => 'slides' }
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @slide.save
      flash[:notice] = 'Slide created'
    end
    respond_with @slide
  end

  def update
    # Works around a checkbox list submitting nothing if all are unchecked
    params[:slide][:sign_ids] ||= []
    if @slide.update_attributes(params[:slide])
      flash[:notice] = 'Slide updated'
    end
    respond_with @slide
  end

  def destroy
    if @slide.destroy
      flash[:notice] = 'Slide deleted'
    end
    respond_with @slide
  end
  
end
