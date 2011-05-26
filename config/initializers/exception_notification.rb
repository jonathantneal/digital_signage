if defined? ::ExceptionNotifier
  SignManager::Application.config.middleware.use ::ExceptionNotifier,
    :email_prefix => "[#{AppConfig.app.name}] ",
    :sender_address => AppConfig.email.from,
    :exception_recipients => [AppConfig.email.developer]
end
