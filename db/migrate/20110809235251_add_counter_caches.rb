class AddCounterCaches < ActiveRecord::Migration
  def self.up
    add_column :slides, :parameters_count, :integer, :default => 0
    add_column :slides, :schedules_count, :integer, :default => 0
    
    Slide.reset_column_information
    Slide.all.each do |slide|
      Slide.update_counters slide.id, :parameters_count => slide.parameters.length, :schedules_count => slide.schedules.length
    end
  end

  def self.down
    remove_column :slides, :schedules_count
    remove_column :slides, :parameters_count
  end
end
