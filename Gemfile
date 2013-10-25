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
gem 'slim'
gem 'httparty'
gem 'jquery-rails'
gem 'kaminari'
gem 'memoist'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'port-a-query'
gem 'rails_config'
gem 'rack-cas'
gem 'ransack'
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
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'pry'
  gem 'thin'
end

group :staging, :production do
  gem 'mysql2'
end

group :production do
  gem 'exception_notification'
end