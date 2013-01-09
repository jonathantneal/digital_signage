class SignSerializer < ActiveModel::Serializer
  attributes  :id, :name, :title, :full_screen_mode, :transition_duration, 
              :reload_interval, :check_in_interval, :updated_at, :video, :audio, 
              :check_in_url, :last_check_in

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
  def last_check_in
    object.last_check_in.try(:to_s, :rfc822)
  end

  def slots
    object.slots.published #.includes(:slide => :schedules)
  end

end
