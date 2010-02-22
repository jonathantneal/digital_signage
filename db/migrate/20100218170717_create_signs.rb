class CreateSigns < ActiveRecord::Migration
  def self.up
    create_table :signs do |t|
      t.string :name, :limit => 20, :null => false
      t.string :title, :limit => 50, :null => false
      t.integer :width, :null => false
      t.integer :height, :null => false
      t.boolean :video, :default => false, :null => false
      t.boolean :audio, :default => false, :null => false
      t.time :on
      t.time :off
      t.datetime :last_check_in

      t.timestamps
    end
  end

  def self.down
    drop_table :signs
  end
end
