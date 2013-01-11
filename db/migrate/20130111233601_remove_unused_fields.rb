class RemoveUnusedFields < ActiveRecord::Migration
  def up
    remove_column :signs, :video
    remove_column :signs, :audio
    remove_column :signs, :full_screen_mode

    remove_column :slides, :resize
  end

  def down
    add_column :signs, :video, :default => false, :null => false
    add_column :signs, :audio, :default => false, :null => false
    add_column :signs, :full_screen_mode, :string, {:default=>'fullscreen'}

    add_column :slides, :resize, :string, { :default => '', :null => false }
  end
end
