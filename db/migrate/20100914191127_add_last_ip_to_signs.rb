class AddLastIpToSigns < ActiveRecord::Migration
  def self.up
    add_column :signs, :last_ip, :string
  end

  def self.down
    remove_column :signs, :last_ip
  end
end
