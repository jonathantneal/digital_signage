Kaminari.configure do |config|
  config.default_per_page = Settings.ui.pagination.per_page
  config.window = 4
  config.outer_window = 0
  config.left = 2
  config.right = 2
end
