class AddEditableContentToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :editable_content, :text
  end
end
