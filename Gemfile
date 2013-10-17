source 'http://rubygems.org'

gem 'rails', '3.2.13'

gem 'action_links'
gem 'active_model_serializers'
gem 'addressable'
gem 'carrierwave', '~> 0.7.1' # Test actual display page (on site with relative_url_root) before updating that the image links aren't broken
gem 'chronic'
gem 'daemons', '~> 1.1.9'
gem 'declarative_authorization'
gem 'font-awesome-rails'
gem 'haml'
gem 'slim'
gem 'httparty'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
gem 'kaminari'
gem 'memoist'
gem 'meta_search'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'port-a-query'
gem 'rack-cas'
gem 'turnout'
gem 'version'
gem 'viva-app_config', :require=>'app_config'
gem 'yaml_db'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'pry'
  gem 'thin'
end

group :assets do
  gem 'bourbon'
  gem 'coffee-rails'
  gem 'compass-rails'
  gem 'sass-rails'
  gem 'therubyracer'
end

group :staging, :production do
  gem 'mysql2'
end

group :production do
  gem 'exception_notification'
end