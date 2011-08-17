class Department < ActiveRecord::Base

  validates_presence_of :title
  has_many :slides
  has_many :signs
  has_many :department_users
  has_many :users, :through => :department_users
  
  def to_s
    self.title
  end
  
end
