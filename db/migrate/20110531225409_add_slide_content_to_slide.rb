class AddSlideContentToSlide < ActiveRecord::Migration
  def self.up
    add_column :slides, :content, :string
    add_column :slides, :content_type, :string
    
    # Allow any extensions
    ContentUploader.class_eval { def extension_white_list() nil end }
    
    Slide.reset_column_information
    Slide.all.each do |slide|
      slide.content.download! slide.uri
      slide.save
    end
    
    remove_column :slides, :uri
  end

  def self.down
    add_column :slides, :uri, :string, :default => '', :null => false
    remove_column :slides, :content
    remove_column :slides, :content_type
  end
end
