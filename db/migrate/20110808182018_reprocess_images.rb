class ReprocessImages < ActiveRecord::Migration

  def self.up
    ContentUploader.class_eval { def extension_white_list() nil end }
    Slide.all.each do |slide|
      slide.content.recreate_versions!
    end
  end

  def self.down
    ContentUploader.class_eval { def extension_white_list() nil end }
    Slide.all.each do |slide|
      slide.content.recreate_versions!
    end
  end
end
