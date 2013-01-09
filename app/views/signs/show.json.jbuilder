json.sign do
  json.(@sign, :name, :title, :full_screen_mode, :transition_duration, :reload_interval, :check_in_interval, :updated_at)
  json.video           to_yn(@sign.video)
  json.audio           to_yn(@sign.audio)
  json.check_in_url    check_in_sign_url
  json.last_check_in   @sign.last_check_in.try(:to_s, :rfc822)

  json.slides @slots do |slot|
    json.(slot.slide, :id, :title, :delay, :resize)
    json.content_type   slot.slide.type
    json.color          '#'+slot.slide.color
    json.uri            absolute_url(slot.slide.content.url)
    json.lastupdate     (slot.slide.updated_at || slot.slide.created_at).to_s(:rfc822)

    json.schedules do
      if !slot.slide.previous_schedule.nil?
        json.schedule do
          json.time    slot.slide.previous_schedule.time.to_s(:rfc822)
          json.action  slot.slide.previous_schedule.action
        end
      end
      if !slot.slide.next_schedule.nil?
        json.schedule do
          json.time    slot.slide.next_schedule.time.to_s(:rfc822)
          json.action  slot.slide.next_schedule.action
        end
      end
    end
  end
end
