class Slot < ActiveRecord::Base

  belongs_to :sign
  belongs_to :slide

  default_scope order('`order`')
  scope :published_status, lambda{ |status|
    # Slide status is defined in Slide::PUBLISHED_STATUS
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
  scope :published, lambda{ joins(:slide).where(Slide.published.where_clauses.join(' AND ')) }
  scope :unpublished, lambda{ joins(:slide).where(Slide.unpublished.where_clauses.join(' AND ')) }
  scope :expired, lambda{ joins(:slide).where(Slide.expired.where_clauses.join(' AND ')) }

  search_methods :published_status
  
  def custom_delay
    self.delay.blank? ? self.slide.delay : self.delay
  end

end
