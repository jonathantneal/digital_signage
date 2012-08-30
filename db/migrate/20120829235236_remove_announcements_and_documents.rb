class RemoveAnnouncementsAndDocuments < ActiveRecord::Migration
  def up
    drop_table :announcements
    drop_table :documents
  end

  def down
    create_table :announcements do |t|
      t.datetime :show_at
      t.text :announcement

      t.timestamps
    end

    create_table :documents do |t|
      t.string :name
      t.text :content
      t.string :slug
      t.string :tags

      t.timestamps
    end
  end
end
