class RenameDelayToInterval < ActiveRecord::Migration
  def change
    rename_column :slides, :delay, :interval
    rename_column :slots, :delay, :interval
  end
end