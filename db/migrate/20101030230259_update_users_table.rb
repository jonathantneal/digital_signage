class UpdateUsersTable < ActiveRecord::Migration

  def self.up
  
    remove_column :users, :persistence_token
    remove_column :users, :login_count
    remove_column :users, :failed_login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :current_login_ip
    remove_column :users, :last_login_ip
    remove_column :users, :roles_mask
    
    add_column :users, :title, :string, :limit=>50, :default=>'', :null=>false
    add_column :users, :department, :string, :limit=>50, :default=>'', :null=>false
    add_column :users, :photo_url, :string, :limit=>200, :default=>'', :null=>false 
    add_column :users, :affiliations, :string, :limit=>100, :default=>'', :null=>false
    add_column :users, :entitlements, :string, :limit=>500, :default=>'', :null=>false
    add_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count, :integer
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
    
  end

  def self.down
  
    remove_column :users, :title
    remove_column :users, :department
    remove_column :users, :photo_url 
    remove_column :users, :affiliations
    remove_column :users, :entitlements
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    
    add_column :users, :persistence_token, :string
    add_column :users, :login_count, :integer, :null=>false, :default=>0
    add_column :users, :failed_login_count, :integer, :null=>false, :default=>0
    add_column :users, :last_request_at, :datetime
    add_column :users, :current_login_at, :datetime
    add_column :users, :last_login_at, :datetime
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string
    add_column :users, :roles_mask, :integer
    
  end

end
