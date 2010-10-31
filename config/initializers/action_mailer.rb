ActionMailer::Base.smtp_settings = {
  :address => AppConfig.email.smtp.server,
  :port => AppConfig.email.smtp.port,
  :domain => AppConfig.email.smtp.domain,
  :enable_starttls_auto => AppConfig.email.smtp.enable_tls,
  :authentication => AppConfig.email.smtp.auth_type.try(:to_sym),
  :user_name => AppConfig.email.smtp.username,
  :password => AppConfig.email.smtp.password
}
