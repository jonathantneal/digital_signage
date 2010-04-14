class AddResizeToSlide < ActiveRecord::Migration
  def self.up
    add_column :slides, :resize, :string, { :default => '', :null => false }
  end

  def self.down
    remove_column :slides, :resize
  end
end
