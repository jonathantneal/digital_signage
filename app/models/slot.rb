class Slot < ActiveRecord::Base

  belongs_to :sign
  belongs_to :slide

  default_scope order('`order`')
  scope :published_eq, lambda{ |status|
    # convert to nil or boolean
    status = (status.to_s.blank?? nil : !['0', 'false'].include?(status.to_s.downcase.strip))
    
    if status.nil?
      scoped
    elsif status
      published
    else
      unpublished
    end
  }
  scope :published, lambda{ joins(:slide).where(Slide.published.where_clauses.join(' AND ')) }
  scope :unpublished, lambda{ joins(:slide).where(Slide.unpublished.where_clauses.join(' AND ')) }

  search_methods :published_eq
  
  def custom_delay
    self.delay.blank? ? self.slide.delay : self.delay
  end

end
