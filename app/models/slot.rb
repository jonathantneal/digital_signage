class Slot < ActiveRecord::Base
  belongs_to :sign
  belongs_to :slide
end
