class SlotsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access :additional_collection => :sort
  respond_to :html, :except => :sort
  respond_to :js, :only => :sort

  def index
    @sign = Sign.where('id = ? OR name = ?', params[:sign_id], params[:sign_id]).first
    raise ActiveRecord::RecordNotFound if @sign.nil?
    @slots = @sign.slots.with_permissions_to(:index).published
  end
  
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
    redirect_to sign_slots_path(@slot.sign)
  end

  def destroy
    if @slot.destroy
      flash[:notice] = 'Slot deleted'
    end
    respond_with @slot.sign, :slots
  end

  def sort
    params[:slot].each_with_index do |id, index|
      Slot.update_all(['`order` = ?', index+1], ['id = ?', id])
    end
    render :nothing => true
  end
  
end
