class AddHeightAndWidthToSign < ActiveRecord::Migration
  def change
    add_column :signs, :height, :integer
    add_column :signs, :width, :integer
  end
end
