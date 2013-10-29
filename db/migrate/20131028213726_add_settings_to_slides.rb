class AddSettingsToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :settings, :text
  end
end
