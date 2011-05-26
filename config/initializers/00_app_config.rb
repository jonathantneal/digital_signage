require 'app_config'
::AppConfig = ApplicationConfiguration.new(
  Rails.root.join('config', 'app_config.yml').to_s,
  Rails.root.join('config', 'environments', "#{Rails.env}.yml").to_s
)
