class RemoveParameters < ActiveRecord::Migration
  def up
    drop_table :parameters
  end

  def down
    create_table :parameters do |t|
      t.references :slide
      t.string :name
      t.string :value

      t.timestamps
    end
  end
end