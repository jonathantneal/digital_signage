class DocumentsController < ApplicationController

  filter_access_to :all

  # GET /documents
  def index
    if params[:tag].blank?
      @search = Document.search(params[:search])
    else
      @search = Document.tagged(params[:tag]).search(params[:search])
      flash[:warn] = "No documents are tagged with \"#{params[:tag]}\"" if @search.count == 0 and params[:search].nil?
    end
    @documents = @search.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.haml
      format.js { render :partial=>'documents' }
    end
  end

  # GET /documents/1
  def show
    @document = Document.find_by_id(params[:id]) || Document.find_by_slug!(params[:id])
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id]) || Document.find_by_slug(params[:id])
  end

  # POST /documents
  def create
    @document = Document.new(params[:document])

    if @document.save
      flash[:notice] = 'Document was successfully created.'
      redirect_to(@document)
    else
      render :action => 'new'
    end
  end

  # PUT /documents/1
  def update
  
    @document = Document.find_by_id(params[:id]) || Document.find_by_slug(params[:id])

    if @document.update_attributes(params[:document])
      flash[:notice] = 'Document was successfully updated.'
      redirect_to(@document)
    else
      render :action => 'edit'
    end
    
  end

  # DELETE /documents/1
  def destroy
  
    @document = Document.find_by_id(params[:id]) || Document.find_by_slug(params[:id])
    @document.destroy

    redirect_to(documents_url)
    
  end
  
end
