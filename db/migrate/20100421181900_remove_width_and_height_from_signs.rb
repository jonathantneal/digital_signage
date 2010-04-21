class RemoveWidthAndHeightFromSigns < ActiveRecord::Migration
  def self.up
    remove_column :signs, :width
    remove_column :signs, :height
  end

  def self.down
    add_column :signs, :width, :integer, {:null=>false}
    add_column :signs, :height, :integer, {:null=>false}
  end
end
