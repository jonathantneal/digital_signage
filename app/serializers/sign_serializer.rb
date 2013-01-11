class SignSerializer < ActiveModel::Serializer
  attributes  :id, :name, :title, :transition_duration, :reload_interval, :check_in_interval,
              :check_in_url, :height, :width

  has_many :slots

  def check_in_url
    check_in_sign_url
  end

  def slots
    object.slots.published #.includes(:slide => :schedules)
  end

end
