class Slot < ActiveRecord::Base

  belongs_to :sign
  belongs_to :slide

  default_scope order('`order`')
  scope :published, joins(:slide).where('slides.published = ?', true)

end
