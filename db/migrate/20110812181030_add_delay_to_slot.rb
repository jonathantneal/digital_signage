class AddDelayToSlot < ActiveRecord::Migration
  def self.up
    add_column :slots, :delay, :integer
  end

  def self.down
    remove_column :slots, :delay
  end
end
