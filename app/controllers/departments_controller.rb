class DepartmentsController < ApplicationController
  filter_resource_access
  respond_to :html
  respond_to :js, :only => :index

  def index
    @departments = Department.order('departments.title')

    @department = Department.new
  end

  def show
    @signs = @department.signs.order('signs.title')
    @users = @department.users.order('username')
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
    if @department.update_attributes(department_params)
      flash[:notice] = 'Department was successfully updated.'
    end
    respond_with @department
  end

  def destroy
    @department.destroy
    respond_with @department
  end

  private

    # Override DeclarativeAuthorization method
    def new_department_from_params
      if params[:department]
        @department = Department.new(department_params)
      else
        @department = Department.new
      end
    end

    # Only allow a trusted parameter "white list" through.
    def department_params
      params.require(:department).permit(:title)
    end
end