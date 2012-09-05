namespace :sign do
  
  desc "Check to see if there are any signs that are down."
  task :check_status => :environment do
    signs = Sign.all

    signs.each do |sign|
      if sign.email && (sign.last_check_in + (sign.check_in_interval * 2) < Time.now)
        # Enforces the frequency in which the emails are sent.
        if sign.email_sent && (sign.email_sent < Time.now - (AppConfig.defaults.sign.email_frequency * 3600))
          AlertMailer.sign_down(sign).deliver
        end
      end
    end
  end
end