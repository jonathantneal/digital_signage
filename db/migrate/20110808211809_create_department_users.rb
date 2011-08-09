class CreateDepartmentUsers < ActiveRecord::Migration
  def self.up
    create_table :department_users do |t|
      t.integer :department_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :department_users
  end
end
