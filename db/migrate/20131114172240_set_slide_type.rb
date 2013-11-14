class SetSlideType < ActiveRecord::Migration
  def up
    Slide.reset_column_information
    Slide.all.each do |slide|
      if slide.html_url.present?
        slide.slide_type = Slide::LINK
      elsif slide.editable_content.present?
        slide.slide_type = Slide::EDITOR
      else
        slide.slide_type = Slide::UPLOAD
      end
      slide.save
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
