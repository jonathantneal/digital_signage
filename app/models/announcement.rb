class Announcement < ActiveRecord::Base

  attr_accessible :show_at, :announcement
  validates_presence_of :show_at, :announcement
  
  default_scope order('show_at DESC')
  scope :current, lambda { where('show_at < ?', DateTime.now.utc) }
  scope :after, lambda { |date| where('show_at > ?', date.utc) }
  
  def show?
    self.show_at < DateTime.now
  end
  
end
