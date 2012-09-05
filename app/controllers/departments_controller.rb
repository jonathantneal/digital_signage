class DepartmentsController < ApplicationController

  before_filter :authenticate_user!
  filter_resource_access
  respond_to :html
  respond_to :js, :only => :index

  def index
    @departments = Department.order(:title)
  end

  def show
    @signs = @department.signs.order(:title)
  end

  def new
  end

  def edit
  end

  def create
    if @department.save
      flash[:notice] = 'Department was successfully created.'
    end
    respond_with @department
  end

  def update
    if @department.update_attributes(params[:department])
      flash[:notice] = 'Department was successfully updated.'
    end
    respond_with @department
  end

  def destroy  
    @department.destroy
    respond_with @department
  end

end
