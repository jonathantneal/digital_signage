class SlidesController < ApplicationController

  load_and_authorize_resource

  # GET /slides
  # GET /slides.xml
  def index
    @search = Slide.search(params[:search])
    @slides = @search.all
    respond_to do |format|
      format.html
      format.xml
    end
  end

  # GET /slides/1
  def show
  end

  # GET /slides/new
  def new
  end

  # GET /slides/1/edit
  def edit
  end

  # POST /slides
  def create
      if @slide.save
        flash[:notice] = 'Slide created'
        redirect_to(@slide)
      else
        render :action => 'new'
      end
  end

  # PUT /slides/1
  def update
  
    # Works around a checkbox list submitting nothing if all are unchecked
    params[:slide][:sign_ids] ||= []

    if @slide.update_attributes(params[:slide])
      flash[:notice] = 'Slide updated'
      redirect_to(@slide)
    else
      render :action => 'edit'
    end
    
  end

  # DELETE /slides/1
  def destroy
    if @slide.destroy
      flash[:notice] = 'Slide deleted'
    end
    redirect_to(slides_url)
  end
  
end
