class Department < ActiveRecord::Base

  has_many :slides, dependent: :destroy
  has_many :signs, dependent: :destroy
  has_many :department_users, dependent: :destroy
  has_many :users, through: :department_users

  validates_presence_of :title

  def to_s
    self.title
  end

end
