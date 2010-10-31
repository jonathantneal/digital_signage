class AnnouncementsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access
  
  # GET /announcements
  def index
    @search = Announcement.search(params[:search] || {:order => :descend_by_show_at})
    @announcements = @search.all.paginate(:page => params[:page], :per_page => 10)

    respond_to do |format|
      format.html
      format.js { render :partial => 'announcements' }
      format.rss
    end
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
    @announcement.show_at = DateTime.now
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    if @announcement.save
      flash[:notice] = 'Announcement was successfully created.'
      redirect_to(@announcement)
    else
      render :action => "new"
    end
  end

  # PUT /announcements/1
  def update
    if @announcement.update_attributes(params[:announcement])
      flash[:notice] = 'Announcement was successfully updated.'
      redirect_to(@announcement)
    else
      render :action => "edit"
    end
  end

  # DELETE /announcements/1
  def destroy
    @announcement.destroy
    redirect_to(announcements_url)
  end
end
