class SlidesController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access
  respond_to :html
  respond_to :js, :only => [:index, :destroy]

  def index
    @search = Slide.search(params[:search])
    @slides = @search.relation.includes(:department).page(params[:page]).per(params[:per] || Kaminari.config.default_per_page)
    respond_with(@slides) do |format|
      format.js do
        render :partial => 'slides' unless params["_"] # Otherwise if infinites scroll render index.js.erb
      end
    end
  end

  def show
  end

  def new
    @slottable_signs = Sign.with_permissions_to(:update).order('signs.title')
    
    # Add all available slots
    @slottable_signs.each do |sign|
      @slide.slots << Slot.new({:sign=>sign})
    end
  end

  def edit
    @slottable_signs = Sign.with_permissions_to(:update).order('signs.title')
  end

  def create
    if @slide.save
      flash[:notice] = 'Slide created'
    end
    respond_with @slide
  end

  def update
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
