AppInfo.configure do |config|
  config.name = AppConfig.app.name
  config.base_url = Rails.configuration.action_controller.relative_url_root || '/'
  config.login_required = AppConfig.security.login.required
  config.user_param = :netid
end