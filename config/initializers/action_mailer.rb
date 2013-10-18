ActionMailer::Base.smtp_settings = {
  :address => Settings.email.smtp.server,
  :port => Settings.email.smtp.port,
  :domain => Settings.email.smtp.domain,
  :enable_starttls_auto => Settings.email.smtp.enable_tls,
  :authentication => Settings.email.smtp.auth_type.try(:to_sym),
  :user_name => Settings.email.smtp.username,
  :password => Settings.email.smtp.password
}

ActionMailer::Base.default_url_options = {
  :host => Settings.app.host,
  :script_name => Settings.app.relative_url_root
}
