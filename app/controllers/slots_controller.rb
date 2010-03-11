class SlotsController < ApplicationController

  load_and_authorize_resource

  # GET /slots
  def index
    @slots = Slot.all
  end

  # GET /slots/1
  def show
  end

  # GET /slots/new
  def new
  end

  # GET /slots/1/edit
  def edit
  end

  # POST /slots
  def create
    if @slot.save
      flash[:notice] = 'Slot created'
      redirect_to(@slot)
    else
      render :action => 'new'
    end
  end

  # PUT /slots/1
  def update
    if @slot.update_attributes(params[:slot])
      flash[:notice] = 'Slot updated'
      redirect_to(@slot)
    else
      render :action => 'edit'
    end
  end

  # DELETE /slots/1
  def destroy
    if @slot.destroy
      flash[:notice] = 'Slot deleted'
    end
    redirect_to(slots_url)
  end
  
end
