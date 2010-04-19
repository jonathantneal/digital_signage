class Sign < ActiveRecord::Base

  attr_accessible :name, :title, :width, :height, :video, :audio, :on, :off, :last_check_in
  validates_presence_of :name, :title, :width, :height, :video, :audio
  validates_uniqueness_of :name, :title
  validates_format_of :name, :with => /^[a-zA-Z0-9-]+$/
  has_many :slots
  has_many :slides, :through => :slots

  def to_param
    self.name
  end

  def checked_in?
    return !self.last_check_in.nil?
  end

  def active_slides
    self.slides.reject { |s| !s.active? }
  end
  
  def expired_slides
    self.slides.reject { |s| s.expired? }
  end

  def active_slides_time
    Slide.total_time self.active_slides
  end
  
  def loop_time # alias
    active_content_time
  end

end
