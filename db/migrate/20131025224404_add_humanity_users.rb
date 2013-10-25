class AddHumanityUsers < ActiveRecord::Migration
  def up
    rename_column :users, :current_sign_in_at, :current_login_at
    rename_column :users, :last_sign_in_at, :last_login_at

    remove_column :users, :affiliations
    remove_column :users, :entitlements
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip

    add_column :users, :login_count, :integer
  end


  def down
    rename_column :users, :current_login_at, :current_sign_in_at
    rename_column :users, :last_login_at, :last_sign_in_at

    add_column :users, :affiliations, :string
    add_column :users, :entitlements, :string
    add_column :users, :remember_token, :string
    add_column :users, :remember_created_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    remove_column :users, :login_count
  end
end
