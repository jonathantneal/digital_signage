class SlotSerializer < ActiveModel::Serializer
  attributes :id

  has_one :slide
end
