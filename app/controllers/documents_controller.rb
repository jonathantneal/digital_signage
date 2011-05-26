class DocumentsController < ApplicationController

  filter_resource_access
  respond_to :html
  respond_to :js, :only => :index

  def index
    @search = Document.tagged(params[:tag]).search(params[:search])
    @documents = @search.paginate(:page => params[:page])
    flash.now[:warn] = 'No documents found' if @search.count.zero?

    respond_with(@documents) do |format|
      format.js { render :partial => 'documents', :locals => { :documents=>@documents } }
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @document.save
      flash[:notice] = 'Document was successfully created.'
    end
    respond_with @document
  end

  def update
    if @document.update_attributes(params[:document])
      flash[:notice] = 'Document was successfully updated.'
    end
    respond_with @document
  end

  def destroy  
    @document.destroy
    respond_with @document
  end
  
  protected
  
  def load_document
    @document = Document.where('id = ? OR slug = ?', params[:id], params[:id]).first
    raise RecordNotFound if @document.nil?
  end
  
end
