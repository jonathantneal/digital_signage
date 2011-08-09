class SlotsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access :additional_collection => :sort
  respond_to :html, :except => :sort
  respond_to :js, :only => :sort

  def index
    @sign = Sign.where('id = ? OR name = ?', params[:sign_id], params[:sign_id]).first
    raise ActiveRecord::RecordNotFound if @sign.nil?
    @slots = @sign.slots.published
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
