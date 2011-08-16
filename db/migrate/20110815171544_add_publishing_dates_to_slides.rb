class AddPublishingDatesToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :publish_at, :datetime
    add_column :slides, :unpublish_at, :datetime
    
    Slide.reset_column_information
    Slide.all.each do |slide|
      slide.update_attributes :publish_at => slide.created_at if slide.published
    end
    
    remove_column :slides, :published
  end

  def self.down
    add_column :slides, :published, :boolean
    
    Slide.reset_column_information
    Slide.all.each do |slide|
      slide.update_attributes :published => true if slide.published?
    end
    
    remove_column :slides, :publish_at
    remove_column :slides, :unpublish_at
  end
end
