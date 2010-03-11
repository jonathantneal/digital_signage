class CreateSchedules < ActiveRecord::Migration
  def self.up
    create_table :schedules do |t|
      t.references :slide, :null => false
      t.string :when, :length => 50, :null => false
      t.boolean :active, :default => false, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :schedules
  end
end
