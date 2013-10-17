class SlidesController < ApplicationController
  filter_resource_access :additional_collection => [:destroy_multiple, :edit_multiple, :update_multiple, :add_to_signs]
  respond_to :html, :except => [:destroy_multiple]
  respond_to :js, :only => [:index, :destroy, :destroy_multiple]

  def index
    if params[:search].blank?
      params[:search] = {published_status: :published}  # Default to only showing published slides
    end

    @search = Slide.search(params[:search])
    @slides = @search.relation.includes(:department).page(params[:page]).per(params[:per] || Kaminari.config.default_per_page)
    @slide = Slide.new
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

  def destroy_multiple
    Slide.find(params[:slide]).each { |slide| slide.destroy if permitted_to? :destroy, slide }
    render :nothing => true
  end

  def edit_multiple
    @slides = Slide.find(params[:s_ids])
  end
  def update_multiple
    @slides = Slide.find(params[:slide_ids])
    @slides.each do |slide|
      slide.update_attributes!(params[:slide].reject {|k,v| v.blank? }) # only update values that aren't blank
    end
    flash[:notice] = "Updated slides!"
    redirect_to slides_path
  end

  def add_to_signs
    signs = Sign.with_permissions_to(:edit).find(params[:sign_ids])  # signs already come as an array
    slides = Slide.with_permissions_to(:index).find(params[:slide_ids].split(','))  # slides come as a comma seperated string

    # Add new slides to each selected sign
    signs.each do |sign|
      sign.slides << slides
    end

    flash[:notice] = "#{slides.length} Slides added to the following signs - #{signs.map{|s| view_context.link_to(s.title, s) }.join(', ')}".html_safe

    redirect_to slides_url
  end
end