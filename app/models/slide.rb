class Slide < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  RESIZE_OPTIONS = ['none', 'zoom', 'zoom & crop', 'stretch']

  attr_accessible :title, :delay, :color, :published, :department_id, :created_at, :updated_at, :sign_id, :sign_ids, :resize, :content, :schedules_attributes, :parameters_attributes, :slots_attributes
  
  belongs_to :department
  has_many :schedules, :dependent => :destroy
  has_many :parameters, :dependent => :destroy
  has_many :slots, :dependent => :destroy
  has_many :signs, :through => :slots
  accepts_nested_attributes_for :schedules, :allow_destroy => true
  accepts_nested_attributes_for :parameters, :allow_destroy => true
  accepts_nested_attributes_for :slots, :allow_destroy => true

  mount_uploader :content, ContentUploader
  
  validates_presence_of :title, :delay, :color, :department_id
  validates_presence_of :content, :on => :create
  validates :title, :uniqueness => true
  validates_inclusion_of :resize, :in => RESIZE_OPTIONS
  validates_integrity_of :content

  before_save :set_content_type
  
  scope :not_on_sign, lambda { |sign|
    joins("LEFT JOIN slots ON (slides.id = slots.slide_id AND slots.sign_id = #{sign.id})").
    group('slides.id').
    where('slots.sign_id IS NULL')
  }

  def valid_schedules(now=@now)
    return [] if schedules.size.zero?
    schedules.reject{ |s| s.time(now).nil? }
  end

  def unpublished?
    return !self.published
  end

  def filename
    content.file.original_filename
  end

  def url(version=nil)
    content.url(version)
  end

  def type
    content_type
  end
  
  def image?
    type.try(:[], 'image/').present?
  end
  
  def video?
    type.try(:[], 'video/').present?
  end
  
  def swf?
    type == 'application/x-shockwave-flash'
  end
  
  def active?(now=Time.now)
    return false unless self.published
    showing?(now)
  end
  
  def inactive?(now=Time.now)
    !active?(now)
  end
  
  def showing?(now=Time.now)
    return true if valid_schedules(now).empty?
    return previous_schedule(now).activate? unless previous_schedule(now).nil?
    return next_schedule(now).deactivate? unless next_schedule(now).nil?
    false  
  end
  
  def hidden?(now=Time.now)
    !showing?(now)
  end

  def expired?(now=Time.now)
    hidden?(now) && future_schedules(now).empty?
  end

  def expired_at(now=Time.now)
    previous_schedule(now).try(:time) if expired?(now)
  end

  def sorted_schedules(now=Time.now)
    schedules.sort! do |a,b|
      a_time = a.time(now)
      b_time = b.time(now)
      if a_time.nil?
        -1
      elsif b_time.nil?
        1
      else
        a_time <=> b_time
      end
    end
  end
  
  def sorted_valid_schedules(now=Time.now)
    valid_schedules(now).sort! { |a,b| a.time(now) <=> b.time(now) }
  end
  
  def previous_schedule(now=Time.now)
    past_schedules(now).last unless past_schedules(now).empty?
  end
  
  def past_schedules(now=Time.now)
    sorted_valid_schedules(now).reject { |s| s.time(now) > now }
  end

  def next_schedule(now=Time.now)
    future_schedules(now).first unless future_schedules(now).empty?
  end
  
  def future_schedules(now=Time.now)
    sorted_valid_schedules(now).reject { |s| s.time(now) < now }  
  end
  
  def parameter_hash
    params = {}
    self.parameters.each do |param|
      params[param.name] = param.value
    end
    params
  end
  
  # Class Methods
  class << self
    extend ActiveSupport::Memoizable
  
    def expired_slides(now=Time.now)
      Slide.all.reject { |s| !s.expired?(now) }
    end
    
    def total_time(slides)
      time = 0
      slides.each do |slide|
        time += slide.delay
      end
      return time
    end
  
    memoize :expired_slides, :total_time
  end
  
  private
  
  def set_content_type
    if self.respond_to?(:content) && self.respond_to?(:content_type)
      unless content.file.try(:content_type).nil?
        self.content_type = content.file.content_type
      end
    end
  end
  
  memoize :sorted_schedules, :valid_schedules, :sorted_valid_schedules,
    :previous_schedule, :past_schedules, :next_schedule, :future_schedules,
    :parameter_hash
end
