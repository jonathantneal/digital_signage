class AddSettingsToSigns < ActiveRecord::Migration
  def self.up
    add_column :signs, :full_screen_mode, :string, {:default=>'fullscreen'}
    add_column :signs, :transition_duration, :float, {:default=>1}
    add_column :signs, :reload_interval, :integer, {:default=>300}
    add_column :signs, :check_in_interval, :integer, {:default=>180}
  end

  def self.down
    remove_column :signs, :full_screen_mode
    remove_column :signs, :transition_duration
    remove_column :signs, :reload_interval
    remove_column :signs, :check_in_interval
  end
end
