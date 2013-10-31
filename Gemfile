source 'http://rubygems.org'

gem 'rails', '4.0.0'

gem 'action_links'
gem 'active_model_serializers'
gem 'addressable'
gem 'blazing'
gem 'biola_deploy'
gem 'carrierwave', '~> 0.7.1' # Test actual display page (on site with relative_url_root) before updating that the image links aren't broken
gem 'chronic'
gem 'daemons', '~> 1.1.9'
gem 'declarative_authorization'
gem 'font-awesome-rails'
gem 'haml'
gem 'humanity'
gem 'imgkit', '~> 1.3.9'
gem 'slim'
gem 'httparty'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'memoist'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'port-a-query'
gem 'pretender'
gem 'rails_config'
gem 'rack-cas'
gem 'ransack'
gem 'sidekiq'
gem 'turnout'
gem 'version'
gem 'yaml_db'

# Assets
gem 'bourbon'
gem 'coffee-rails'
gem 'sass-rails'
gem 'therubyracer', '~> 0.12.0'
gem 'uglifier'


group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'sqlite3'
  gem 'pry'
  gem 'rspec-rails'
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard', '>= 2.2.2'
  gem 'guard-rspec'
  # gem 'guard-spork'
  gem 'launchy'
  gem 'shoulda-matchers'
  # gem 'spork-rails', '~> 4.0.0'

  # For notifications
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'terminal-notifier-guard', :require => false # sends guard notifications to the OS X Notification Center.
end

group :staging, :production do
  gem 'mysql2'
end

group :production do
  gem 'exception_notification'
end