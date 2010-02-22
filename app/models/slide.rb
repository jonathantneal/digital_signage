class Slide < ActiveRecord::Base

  attr_accessible :title, :uri, :delay, :color, :published, :start_date, :end_date, :user_id, :created_at, :updated_at
  validates_presence_of :title, :uri, :delay, :color, :published, :user_id
  validates_uniqueness_of :title
  belongs_to :user

  def filename
    File.basename URI.parse(self.uri).path
  end
  
end
