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

  def valid_schedules
    self.schedules.reject{ |s| s.time.nil? }
  end

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
  
  def active?(now=Time.now)
    return false if !self.published
    return !self.hidden?(now)
  end
  
  def inactive?(now=Time.now)
    return !self.active?(now)
  end
  
  def showing?(now=Time.now)
    return true if self.valid_schedules.empty?
    return self.previous_schedule(now).activate? unless self.previous_schedule(now).nil?
    return self.next_schedule(now).deactivate? unless self.next_schedule(now).nil?
    return false  
  end
  
  def hidden?(now=Time.now)
    return !self.showing?(now)
  end

  def expired?(now=Time.now)
    return self.hidden?(now) && self.future_schedules(now).empty?
  end

  def expired_at(now=Time.now)
    return self.previous_schedule(now).try(:time) if self.expired?(now)
  end

  def sorted_schedules(now=Time.now)
    self.valid_schedules.sort! { |a,b| a.time(now) <=> b.time(now) }
  end
  
  def previous_schedule(now=Time.now)
    self.past_schedules(now).last unless self.past_schedules(now).empty?
  end
  
  def past_schedules(now=Time.now)
    self.sorted_schedules(now).reject { |s| s.time(now) > now }
  end

  def next_schedule(now=Time.now)
    self.future_schedules(now).first unless self.future_schedules(now).empty?
  end
  
  def future_schedules(now=Time.now)
    self.sorted_schedules(now).reject { |s| s.time(now) < now }  
  end
  
  def self.expired_slides(now=Time.now)
    Slide.all.reject { |s| !s.expired?(now) }
  end
  
  def self.total_time(slides)
    time = 0
    slides.each do |slide|
      time += slide.delay
    end
    return time
  end
  
end
