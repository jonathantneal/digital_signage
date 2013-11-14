if defined? ::ExceptionNotification
  SignManager::Application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: "[#{Settings.app.name}] ",
      sender_address: Settings.email.from,
      exception_recipients: Settings.email.developer
    }
end