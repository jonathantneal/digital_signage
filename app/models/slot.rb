class Slot < ActiveRecord::Base

  belongs_to :sign
  belongs_to :slide

  default_scope order('`order`')
  scope :published, lambda{ joins(:slide).where(Slide.published.where_clauses.join(' AND ')) }
  scope :unpublished, lambda{ joins(:slide).where(Slide.unpublished.where_clauses.join(' AND ')) }

  def custom_delay
    self.delay.blank? ? self.slide.delay : self.delay
  end

end
