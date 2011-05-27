class ResizeEntitlementsColumn < ActiveRecord::Migration
  def self.up
    change_column :users, :entitlements, :string, :limit=>2000, :default=>'', :null=>false
  end

  def self.down
    change_column :users, :entitlements, :string, :limit=>500, :default=>'', :null=>false
  end
end
