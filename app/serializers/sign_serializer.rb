class SignSerializer < ActiveModel::Serializer
  attributes  :id, :name, :title, :full_screen_mode, :transition_duration, 
              :reload_interval, :check_in_interval, :video, :audio, 
              :check_in_url

  has_many :slots

  def video
    object.video ? 'yes' : 'no'
  end
  def audio
    object.audio ? 'yes' : 'no'
  end
  def check_in_url
    check_in_sign_url
  end

  def slots
    object.slots.published #.includes(:slide => :schedules)
  end

end
