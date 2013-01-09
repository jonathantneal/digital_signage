class AddHtmlWidgetToSlide < ActiveRecord::Migration
  def change
    add_column :slides, :html_url, :string
  end
end
