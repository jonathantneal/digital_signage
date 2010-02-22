class User < ActiveRecord::Base

  attr_accessible :username, :first_name, :last_name, :email, :last_login_at
  validates_presence_of :username, :first_name, :last_name, :email
  validates_uniqueness_of :username, :email
  has_many :slides
  
  def name
    (self.first_name + ' ' + self.last_name).strip
  end

end
