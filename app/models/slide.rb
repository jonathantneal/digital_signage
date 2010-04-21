class Slide < ActiveRecord::Base

  RESIZE_OPTIONS = ['none', 'zoom', 'zoom & crop', 'stretch']

  attr_accessible :title, :uri, :delay, :color, :published, :user_id, :created_at, :updated_at, :sign_ids, :schedules_attributes, :resize
  validates_presence_of :title, :uri, :delay, :color, :user_id
  validates_uniqueness_of :title
  validates_uri_existence_of :uri
  validates_inclusion_of :resize, :in => self::RESIZE_OPTIONS
  belongs_to :user
  has_many :schedules, {:dependent=>:destroy}
  has_many :slots, {:dependent=>:destroy}
  has_many :signs, :through => :slots
  accepts_nested_attributes_for :schedules, :allow_destroy => true

  def published?
    return self.published
  end

  def unpublished?
    return !self.published
  end

  def filename
    File.basename URI.parse(self.uri).path
  end

  def type
    begin
      require 'net/http'
      url = URI.parse(self.uri)
      request = Net::HTTP.new(url.host, url.port)
      response = request.request_head(url.path)
      return response['Content-Type']
    rescue
      return 'application/x-unknown-content-type'
    end
  end
  
  def image?
    return !self.type['image/'].nil?
  end
  
  def video?
    return !self.type['video/'].nil?
  end
  
  def swf?
    return self.type == 'application/x-shockwave-flash'
  end
  
  def active?(time=Time.now)
    return false if !self.published
    return !self.hidden?
  end
  
  def inactive?(time=Time.now)
    return !self.active?(time)
  end
  
  def showing?(time=Time.now)
    return true if self.schedules.empty?
    return self.previous_schedule.activate? unless self.previous_schedule.nil?
    return self.next_schedule.deactivate? unless self.next_schedule.nil?
    return false  
  end
  
  def hidden?(time=Time.now)
    return !self.showing?
  end

  def expired?
    return self.hidden? && self.future_schedules.empty?
  end

  def expired_at
    return self.previous_schedule.try(:time) unless !self.expired?
  end

  def sorted_schedules
    self.schedules.sort! { |a,b| a.time <=> b.time }
  end
  
  def previous_schedule
    self.past_schedules.last unless self.past_schedules.empty?
  end
  
  def past_schedules
    self.sorted_schedules.reject { |s| s.time > Time.now }
  end

  def next_schedule
    self.future_schedules.first unless self.future_schedules.empty?
  end
  
  def future_schedules
    self.sorted_schedules.reject { |s| s.time < Time.now }  
  end
  
  def self.expired_slides
    Slide.all.reject { |s| !s.expired? }
  end
  
  def self.total_time(slides)
    time = 0
    slides.each do |slide|
      time += slide.delay
    end
    return time
  end
  
end
