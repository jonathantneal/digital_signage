class Sign < ActiveRecord::Base

  attr_accessible :name, :title, :width, :height, :video, :audio, :on, :off, :last_check_in
  validates_presence_of :name, :title, :width, :height, :video, :audio
  validates_uniqueness_of :name, :title
  has_many :slides, :through => :slots

end
