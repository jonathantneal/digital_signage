class Sign < ActiveRecord::Base
  extend ActiveSupport::Memoizable  

  FULL_SCREEN_MODES = ['fullscreen', 'maximize']

  attr_accessible :name, :title, :video, :audio, :on, :off, :full_screen_mode, :transition_duration, :reload_interval, :check_in_interval, :department_id, :slide_id
  validates_presence_of :name, :title, :full_screen_mode, :transition_duration, :reload_interval, :check_in_interval, :department_id
  validates_uniqueness_of :name, :title
  validates_numericality_of :transition_duration, :greater_than => 0
  validates_numericality_of :reload_interval, :only_integer => true, :greater_than => 0
  validates_numericality_of :check_in_interval, :only_integer => true, :greater_than => 0
  validates_inclusion_of :full_screen_mode, :in => FULL_SCREEN_MODES
  validates_format_of :name, :with => /^[a-zA-Z0-9_-]+$/
  belongs_to :department
  has_many :slots, :dependent=>:destroy
  has_many :slides, :through => :slots#, :order=>'slots.order'
  

  def to_param
    self.name
  end

  def checked_in?
    return !self.last_check_in.nil?
  end

  def active_slides
    self.slides.includes(:schedules).reject { |s| !s.active? }
  end
  
  def expired_slides
    self.slides.includes(:schedules).reject { |s| !s.expired? }
  end

  def active_slides_time
    Slide.total_time self.active_slides
  end
  alias :loop_time :active_slides_time

  memoize :active_slides, :expired_slides, :active_slides_time
end
