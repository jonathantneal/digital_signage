class SlotsController < ApplicationController

  load_and_authorize_resource

  # GET /slots
  def index
    @sign = Sign.find_by_id(params[:sign_id]) || Sign.find_by_name(params[:sign_id])
    @slots = Slot.all(:conditions=>"sign_id=#{@sign.id}", :order=>'`order`')
  end

  # DELETE /slots/1
  def destroy
    if @slot.destroy
      flash[:notice] = 'Slot deleted'
    end
    redirect_to(slots_url)
  end

  def sort
    params[:slot].each_with_index do |id, index|
      Slot.update_all(['`order`=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
end
