class ChangeUserToDepartmentInSlides < ActiveRecord::Migration
  def self.up
    rename_column :slides, :user_id, :department_id
  end

  def self.down
    rename_column :slides, :department_id, :user_id
  end
end
