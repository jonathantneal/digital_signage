class Parameter < ActiveRecord::Base
  belongs_to :slide, :counter_cache => true
  attr_accessible :name, :value
end
