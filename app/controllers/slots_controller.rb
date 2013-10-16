class SlotsController < ApplicationController
  filter_resource_access :additional_collection => [:sort, :destroy_multiple]
  respond_to :html, :except => [:sort, :destroy_multiple]
  respond_to :js, :only => [:sort, :destroy_multiple]

  def edit
  end

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

  def destroy_multiple
    Slot.find(params[:slot]).each { |slot| slot.destroy if permitted_to? :destroy, slot }
    render :nothing => true
  end

  def sort
    params[:slot].each_with_index do |id, index|
      Slot.update_all(['`order` = ?', index+1], ['id = ?', id])
    end
    render :nothing => true
  end
end