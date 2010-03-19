class Slide < ActiveRecord::Base

  attr_accessible :title, :uri, :delay, :color, :published, :user_id, :created_at, :updated_at, :sign_ids, :schedules_attributes
  validates_presence_of :title, :uri, :delay, :color, :user_id
  validates_uniqueness_of :title
  belongs_to :user
  has_many :schedules
  has_many :slots
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
    require 'net/http'
    url = URI.parse(self.uri)
    request = Net::HTTP::Head.new(url.path)
    response = Net::HTTP.start(url.host, url.port) do |http|
      http.request(request)
    end
    return response['Content-Type']
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
