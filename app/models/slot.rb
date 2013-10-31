class Slot < ActiveRecord::Base

  belongs_to :sign
  belongs_to :slide
  has_one :department, through: :slide

  default_scope { order('`order`') }
  scope :published_status, ->(status) {
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
  scope :published, -> { joins(:slide).where(Slide.published.where_clauses.join(' AND ')) }
  scope :unpublished, -> { joins(:slide).where(Slide.unpublished.where_clauses.join(' AND ')) }
  scope :expired, -> { joins(:slide).where(Slide.expired.where_clauses.join(' AND ')) }

end
