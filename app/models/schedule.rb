class Schedule < ActiveRecord::Base

  ACTIVE_OPTIONS = [['hide',false], ['show',true]]

  belongs_to :slide, :counter_cache => true

  validates_presence_of :when
  validates_uniqueness_of :when, :scope => :slide_id
  validates :when, :time_string => true

  after_initialize { @now = Time.now }

  def activate?
    return self.active
  end

  def deactivate?
    return !self.active
  end

  def action
    Schedule::ACTIVE_OPTIONS[self.active ? 1 : 0][0]
  end

  def time(now=@now)

    if @time.nil?

      if self.really_today?(now)
        @time = self.parse(now).advance(:weeks => -1)
      else
        @time = self.parse(now)
      end

    end

    return @time

  end

  protected
  def parse(now=@now)
    return Chronic.parse(self.when, :now => now)
  end

  # If today is Monday and the string to parse is 'Monday' Chronic will assume
  # it's next Monday, rather than today. This code detects that
  def really_today?(now=@now)

    parsed_time = self.parse

    unless now.nil? || parsed_time.nil?

      # If the parsed date is one week from today
      if parsed_time.same_day?(now.advance(:weeks => 1))

        last_week_parsed_time = self.parse(now.advance(:weeks => -1))

        # If parsing the date one week ago gives us today
        return true if last_week_parsed_time.try(:same_day?, now)

      end

    end

    return false

  end

  public
  def to_s
    return self.when + ': ' + self.action
  end

end
