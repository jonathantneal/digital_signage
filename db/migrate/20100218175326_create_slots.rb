class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.references :sign, :null => false
      t.references :slide, :null => false
      t.integer :order, :default => 0, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :slots
  end
end
