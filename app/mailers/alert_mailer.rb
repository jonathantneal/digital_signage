class AlertMailer < ActionMailer::Base
  default from: AppConfig.email.from

  def sign_down(sign)
    @sign = sign
    time = Time.now - @sign.last_check_in
    hours = (time/3600).to_i
    minutes = (time/60 - hours*60).to_i
    seconds = (time - (minutes*60 + hours*3600)).to_i
    @down_time = "%02d:%02d:%02d" % [hours, minutes, seconds]

    mail to: sign.email, subject: "The #{@sign.title} sign is currently down"

    @sign.email_sent = Time.now
    @sign.save
  end
end
