class SlidesController < ApplicationController
  filter_resource_access additional_collection: [:destroy_multiple, :edit_multiple, :update_multiple, :add_to_signs, :drop_create], additional_member: [:show_editable_content]
  respond_to :html, except: [:destroy_multiple]
  respond_to :js, only: [:index, :destroy, :destroy_multiple]

  def index
    if params[:q].blank?
      # params[:search] = {published_status: :published}  # Default to only showing published slides
    end

    @q = Slide.search(params[:q])
    @slides = @q.result(distinct: true).published_status(params[:published_status]).includes(:department).page(params[:page]).per(20)

    # create new slide for dropdown form.
    @slide = Slide.new

    respond_with(@slides) do |format|
      format.js do
        render partial: 'slides' unless params["_"] # Otherwise if infinites scroll render index.js.erb
      end
    end
  end

  def show
  end

  def show_editable_content
    render :layout => false
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
    @slide.publish_at ||= Time.now

    case params[:options]
    when 'upload'
      @slide.html_url = ''
    when 'link'
      @slide.content = nil
    when 'editor'
      @slide.is_editor = true
      @slide.html_url = ''
      @slide.content = nil
      @slide.background_color = 'rgba(255,255,255,1)'
    end

    if @slide.save
      flash[:notice] = 'Slide created'
    end
    respond_with @slide
  end

  def update
    if @slide.update_attributes(slide_params)
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

  def drop_create
    slide = Slide.from_drop params[:file], current_user.departments.first

    message = "Slide with title already exists" if slide.persisted?

    if slide.save
      flash[:notice] = message || "Slide has been created"
      render :json => { result: 'success' }
    else
      flash[:danger] = "There was a problem creating the slide"
      render :json => { result: 'error' }
    end
  end

  private

    # Override DeclarativeAuthorization method
    def new_slide_from_params
      if params[:slide]
        @slide = Slide.new(slide_params)
      else
        @slide = Slide.new
      end
    end

    # Only allow a trusted parameter "white list" through.
    def slide_params
      params.require(:slide).permit(
        :title, :interval, :department_id, :publish_at, :unpublish_at,
        :html_url, :content, :content_cache, :editable_content,
        :sign_ids,  # for creating a new slide from the sign page.
        :is_editor, :background_color, :overlay_color,
        schedules_attributes: [:when, :active, :id, :_destroy], slots_attributes: [:sign_id, :id, :_destroy]
      )
    end
end