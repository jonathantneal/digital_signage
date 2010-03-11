class CreateSlides < ActiveRecord::Migration
  def self.up
    create_table :slides do |t|
      t.string :title, :limit => 50, :null => false
      t.text :uri, :default => '', :null => false
      t.integer :delay, :default => 5, :null => false
      t.string :color, :limit => 6, :default => '000000', :null => false
      t.boolean :published, :default => false, :null => false
      t.references :user, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :slides
  end
end
