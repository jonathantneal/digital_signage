class AddDepartmentToSign < ActiveRecord::Migration
  def self.up
    add_column :signs, :department_id, :integer
  end

  def self.down
    remove_column :signs, :department_id
  end
end
