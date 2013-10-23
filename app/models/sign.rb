class Sign < ActiveRecord::Base
  extend Memoist

  attr_accessible :name, :title, :on, :off, :transition_duration, :reload_interval,
                  :check_in_interval, :department_id, :slide_id, :email, :width, :height
  validates_presence_of :name, :title, :transition_duration, :reload_interval, :check_in_interval, :department_id
  validates_uniqueness_of :name, :title
  validates_numericality_of :transition_duration, :greater_than => 0
  validates_numericality_of :reload_interval, :only_integer => true, :greater_than => 0
  validates_numericality_of :check_in_interval, :only_integer => true, :greater_than => 0
  validates_format_of :name, :with => /^[a-zA-Z0-9_-]+$/
  belongs_to :department
  has_many :slots, :dependent=>:destroy
  has_many :slides, :through => :slots#, :order=>'slots.order'

  def to_s
    title
  end

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

  def status
    if self.last_check_in.blank?
      return :never_checked_in
    elsif self.last_check_in + (self.check_in_interval * 2) < Time.now
      return :down
    else
      return :up
    end
  end

  def down?
    case self.status
    when :down
      return true
    else
      return false
    end
  end

  def send_down_alert?
    send_alert = false
    if self.down? && !self.email.blank?
      if self.email_sent.blank?
        send_alert = true
      elsif self.email_sent < Time.now - (Settings.defaults.sign.email_frequency * 3600)
        send_alert = true
      end
    end
    return send_alert
  end

  alias :loop_time :active_slides_time

  memoize :active_slides, :expired_slides, :active_slides_time
end
