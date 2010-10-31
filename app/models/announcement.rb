class Announcement < ActiveRecord::Base

  attr_accessible :show_at, :announcement
  validates_presence_of :show_at, :announcement
  
  default_scope :order=>'show_at DESC'
  named_scope :current, lambda { { :conditions => ['show_at < ?', DateTime.now.utc] } }
  named_scope :after, lambda { |date| { :conditions => ['show_at > ?', date.utc] } }
  
  def show?
    self.show_at < DateTime.now
  end
  
end
