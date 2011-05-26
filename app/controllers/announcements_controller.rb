class AnnouncementsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access
  respond_to :html
  respond_to :js, :only => :index
  
  def index
    @search = Announcement.search(params[:search])
    @announcements = @search.all.paginate(:page => params[:page], :per_page => 10)
    flash.now[:warn] = 'No documents found' if @search.count.zero?

    respond_with(@announcements) do |format|
      format.js { render :partial => 'announcements', :locals => { :announcements => @announcements } }
    end
  end

  def show
  end

  def new
    @announcement.show_at = DateTime.now
  end

  def edit
  end

  def create
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
    end
    respond_with @announcement
  end

  def update
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = 'Announcement was successfully updated.'
    end
    respond_with @announcement
  end

  def destroy
    @announcement.destroy
    respond_with @announcement
  end
end
