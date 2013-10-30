class SlotsController < ApplicationController
  filter_resource_access

  def create
    if @slot.save
      flash[:notice] = 'Added  created'
    end

    redirect_to :back
  end

  def update
    if @slot.update_attributes(params[:slot])
      flash[:notice] = 'Slot updated'
    end
    redirect_to @slot.sign
  end

  def destroy
    @sign = @slot.sign
    @slot.destroy
    render :nothing => true
  end
end