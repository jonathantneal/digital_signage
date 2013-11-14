class Slide < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  extend Memoist
  PUBLISHED_STATUS = ['published', 'unpublished', 'expired']

  # Slide Types
  UPLOAD = 'upload'
  LINK = 'link'
  EDITOR = 'editor'
  SLIDE_TYPES = [UPLOAD, LINK, EDITOR]

  store :settings, accessors: [:slide_type, :background_color, :overlay_color]

  belongs_to :department
  has_many :schedules, :dependent => :destroy
  has_many :slots, :dependent => :destroy
  has_many :signs, :through => :slots
  accepts_nested_attributes_for :schedules, :allow_destroy => true
  accepts_nested_attributes_for :slots, :allow_destroy => true

  after_initialize :defaults
  after_save :schedule_url_screengrab

  mount_uploader :content, ContentUploader

  validates_presence_of :title, :interval, :department_id
  validates_integrity_of :content
  validates :slide_type, inclusion: { in: SLIDE_TYPES }
  validates_each :unpublish_at, :allow_nil => true do |record, attr, value|
    if record.publish_at.to_i > value.to_i
      record.errors.add :publish_at, "can't be after the unpublish date"
    end
  end

  scope :published_status, ->(status) {
    case status
    when 'published'
      published
    when 'unpublished'
      unpublished
    when 'expired'
      expired
    else
      scoped
    end
  }
  scope :published, -> {
    where(
      '(slides.publish_at IS NULL AND slides.unpublish_at > ?)
      OR (slides.unpublish_at IS NULL AND slides.publish_at < ?)
      OR (? BETWEEN slides.publish_at AND slides.unpublish_at)',
      *[DateTime.now]*3
    )
  }
  scope :unpublished, -> {
    where(
      '(slides.publish_at IS NULL AND slides.unpublish_at IS NULL)
      OR (slides.publish_at IS NULL AND slides.unpublish_at < ?)
      OR (slides.unpublish_at IS NULL AND slides.publish_at > ?)
      OR (slides.publish_at IS NOT NULL AND slides.unpublish_at IS NOT NULL AND ? NOT BETWEEN slides.publish_at AND slides.unpublish_at)',
      *[DateTime.now]*3
    )
  }
  scope :expired, -> { where('(slides.unpublish_at < ?)', DateTime.now) }

  scope :not_on_sign, ->(sign) {
    joins("LEFT JOIN slots ON (slides.id = slots.slide_id AND slots.sign_id = #{sign.id})").
    group('slides.id').
    where('slots.sign_id IS NULL')
  }
  scope :belongs_to_sign, ->(sign) {
    joins("INNER JOIN slots ON (slides.id = slots.slide_id)").
    where("slots.sign_id = #{sign.id}").
    order("`order`")
  }


  def filename
    content.file.original_filename if has_content?
  end

  def url(version=nil)
    (html_url.presence || editable_content_url.presence || content_url(version)).to_s
  end

  def type
    if editor? || link?
      "text/html"
    else
      content_type || "text/html"
    end
  end

  def image?
    type.try(:[], 'image/').present?
  end

  def video?
    type.try(:[], 'video/').present?
  end

  def upload?
    (slide_type == UPLOAD) || (!link? & !editor?)
  end

  def link?
    slide_type == LINK
  end

  def editor?
    slide_type == EDITOR
  end

  def editable_content_url
    Rails.application.routes.url_helpers.show_editable_content_slide_url(self, host: Settings.app.host, port: Settings.app.port, script_name: Settings.app.relative_url_root) if self.editor?
  end

  def has_content?
    # for some reason, content.blank? on staging returns false even when there is content available
    !content.file.nil?
  end




  #####  Slide status methods

  def published?
    if publish_at.nil? && unpublish_at.nil?
      false
    elsif unpublish_at.nil?
      publish_at.past?
    elsif publish_at.nil?
      unpublish_at.future?
    else
      publish_at.past? && unpublish_at.future?
    end
  end

  def unpublished?
    !published?
  end

  def expired?
    # Things that are expired are also unpublished, but expired should take presidence.
    unpublish_at.present? && unpublish_at.past?
  end




  #####  Scheduling Methods

  def valid_schedules(now=@now)
    return [] if schedules.size.zero?
    schedules.reject{ |s| s.time(now).nil? }
  end

  def showing?(now=Time.now)
    return false if unpublished?
    return true if valid_schedules(now).empty?
    return previous_schedule(now).activate? unless previous_schedule(now).nil?
    return next_schedule(now).deactivate? unless next_schedule(now).nil?
    false
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




  #### Class Methods

  def self.from_drop(file, department)
    # unless slide = Slide.find_by_title(file.original_filename)
    slide = Slide.new
    slide.content     = file
    slide.title       = file.original_filename
    slide.department  = department
    slide.publish_at  = Time.now
    slide
  end


  private

    def defaults
      if new_record?
        self.interval ||= Settings.defaults.slide.interval
        self.background_color ||= 'rgba(255,255,255,1)' if self.editor?   # default editor background to white
        self.background_color ||= Settings.defaults.slide.background_color
        self.slide_type ||= UPLOAD if self.has_content?
        self.slide_type ||= EDITOR
      end
    end

    def schedule_url_screengrab
      if html_url.present?
        begin
          UrlImageWorker.perform_async(self.id) unless self.has_content?
        rescue Exception=>e
          # Redis may not be on. So just skip this for now.
        end
      end
    end

    def save_url_preview_image(width = 1920, height = 1080)
      if self.html_url.present?
        file = Tempfile.new(["template_#{self.id.to_s}", '.jpg'], 'tmp', :encoding => 'ascii-8bit')
        file.write IMGKit.new(self.html_url, width: width, height: height).to_jpg
        file.rewind
        self.content = file
        file.unlink
      end
    end


  memoize :published?, :expired?,
    :sorted_schedules, :valid_schedules, :sorted_valid_schedules,
    :previous_schedule, :past_schedules, :next_schedule, :future_schedules
end
