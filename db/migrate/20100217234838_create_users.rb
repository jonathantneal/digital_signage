class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :limit => 20, :null => false
      t.string :first_name, :limit => 20, :default => '', :null => false
      t.string :last_name, :limit => 20, :default => '', :null => false
      t.string :email, :limit => 50, :default => '', :null => false
      t.integer :roles_mask, :default => 0, :null => false
      t.string :persistence_token, :limit => 128, :default => '', :null => false
      t.integer :login_count, :default => 0, :null => false
      t.integer :failed_login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip, :limit => 15, :default => '', :null => false
      t.string :last_login_ip, :limit => 15, :default => '', :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
