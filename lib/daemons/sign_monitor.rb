#!/usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'development'

# Load AppConfig manually since Rails isn't loaded yet
require 'app_config'
app_config = ApplicationConfiguration.new(File.dirname(__FILE__) + '/../../config/app_config.yml')
# Need to set RAILS_RELATIVE_URL_ROOT so the URLs in emails are right
ENV['RAILS_RELATIVE_URL_ROOT'] = app_config.app.relative_url_root

require File.dirname(__FILE__) + '/../../config/application'
Rails.application.require_environment!

$running = true
Signal.trap('TERM') do 
  $running = false
end

while($running) do
  puts "#{Time.now} - Checking for down signs..."
  Sign.all.each do |sign|
    # Log that the sign is down
    if sign.down?
      puts = "[#{Time.now}] Sign #{sign.name} is down. #{sign.inspect}"
      # Log whether an alert was sent
      if sign.send_down_alert?
        puts "[#{Time.now}] Sending alert for sign=#{sign.name} to #{sign.email}."
        AlertMailer.sign_down(sign).deliver if sign.send_down_alert?  
      else
        #why aren't we sending an alert?
        reason = "[#{Time.now}] Skipping alert for sign=#{sign.name}. reason= "
        reason << (sign.email ? "Already sent email within scheduled time period of #{app_config.defaults.sign.email_frequency} hour(s)." : "No alert email set.")
        puts reason
      end
    end
  end
  
  sleep 60 #in seconds
end
