class SlotsController < ApplicationController

  #before_filter :authenticate_user!
  #filter_access_to :index, :destroy, :sort

  # GET /slots
  def index
    @sign = Sign.find_by_id(params[:sign_id]) || Sign.find_by_name(params[:sign_id])
    @slots = Slot.all(:conditions=>"sign_id=#{@sign.try(:id)}", :order=>'`order`')
  end

  # DELETE /slots/1
  def destroy
    if @slot.destroy
      flash[:notice] = 'Slot deleted'
    end
    redirect_to(sign_slots_url(@slot.sign))
  end

  def sort
    params[:slot].each_with_index do |id, index|
      Slot.update_all(['`order`=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
end
