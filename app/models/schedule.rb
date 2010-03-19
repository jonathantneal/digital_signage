class Schedule < ActiveRecord::Base

  attr_accessible :slide, :when, :active
  belongs_to :slide
  validates_presence_of :slide, :when
  validates_uniqueness_of :when, :scope => :slide_id
  
  ACTIVE_OPTIONS = [['hide',false], ['show',true]]

  def activate?
    return self.active
  end
  
  def deactivate?
    return !self.active
  end

  def action
    Schedule::ACTIVE_OPTIONS[self.active ? 1 : 0][0]    
  end
  
  def after_initialize
    @now = Time.now
  end
  
  def time
    if self.really_today?
      return self.parse.advance(:weeks => -1)
    else
      return self.parse
    end
  end
  
  protected
  def parse(now=@now)
    return Chronic.parse(self.when, { :now => now })
  end
  
  # If today is Monday and the string to parse is 'Monday' Chronic will assume
  # it's next Monday, rather than today. This code get's around that
  def really_today?
  
    parsed_time = self.parse
    one_week = @now.advance(:weeks => 1)
    
    # If the parsed date is one week from today
    if self.same_day?(parsed_time, one_week)
      
      one_week_parsed_time = self.parse(one_week)
      two_weeks = @now.advance(:weeks => 2)
    
      # If parsing the date one week from now gives us two weeks from now
      return true if self.same_day?(one_week_parsed_time, two_weeks)
      
    end
    
    return false
    
  end
  
  def same_day?(time1, time2)
    return time1.year == time2.year && time1.yday == time2.yday
  end
  
  public
  def to_s
    return self.when + ': ' + self.action
  end
  
end
