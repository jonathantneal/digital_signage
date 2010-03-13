class User < ActiveRecord::Base

  attr_accessible :username, :first_name, :last_name, :email, :last_login_at, :roles_mask
  validates_presence_of :username, :first_name, :last_name, :email
  validates_uniqueness_of :username, :email
  has_many :slides

  ROLES = ['admin','content_admin', 'contributor']

  # PLUGIN: authlogic
  acts_as_authentic do |c|
    c.validate_netid_login = false
  end
  
  def name
    (self.first_name + ' ' + self.last_name).strip
  end

  def active_slides
    self.slides.reject { |s| !s.active? }
  end
  
  def expired_slides
    self.slides.reject { |s| s.expired? }
  end

  def active_slides_time
    Slide.total_time self.active_slides
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role_symbols
    roles.map(&:to_sym)
  end

end
