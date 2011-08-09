class Parameter < ActiveRecord::Base
  belongs_to :slide
  attr_accessible :name, :value
end
