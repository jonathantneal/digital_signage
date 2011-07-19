FeedSatisfaction.config do |config|
  config.domain = AppConfig.feedback.domain
  config.company = AppConfig.feedback.company
  config.product = AppConfig.feedback.product
  config.fastpass_key = AppConfig.feedback.fastpass.key
  config.fastpass_secret = AppConfig.feedback.fastpass.secret
  config.widget_id = AppConfig.feedback.widget_id
  config.custom_css = AppConfig.feedback.custom_css
  config.default_tab = AppConfig.feedback.default_tab
  config.question_limit = AppConfig.feedback.question_limit
  config.sidebar_name = :aside
end
