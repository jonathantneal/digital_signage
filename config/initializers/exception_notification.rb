if defined? ::ExceptionNotifier
  SignManager::Application.config.middleware.use ::ExceptionNotifier,
    :email_prefix => "[#{Settings.app.name}] ",
    :sender_address => Settings.email.from,
    :exception_recipients => [Settings.email.developer]
end
