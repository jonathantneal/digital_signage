source 'http://rubygems.org'
source 'https://gems.biola.edu'

gem 'rails', '3.2.10'

gem 'action_links', '~> 0.4.1'
gem 'addressable', '~> 2.3.2'
gem 'appinfo', '~> 0.1.1'
gem 'carrierwave', '~> 0.7.1'
gem 'chronic', '~> 0.8.0'
gem 'daemons', '~> 1.1.9'
gem 'declarative_authorization', '~> 0.5.3'
gem 'haml', '~> 3.1.7'
gem 'httparty', '~> 0.9.0'
gem 'jbuilder', '~> 0.9.1'
gem 'jquery-rails', '~> 2.1.1'
gem 'jquery-ui-rails', '~> 2.0.0'
gem 'jquery-ui-themes', '~> 0.0.7'
gem 'kaminari', '~> 0.14.1'
gem 'memoist', '~> 0.2.0'
gem 'meta_search', '~> 1.1.1'
gem 'mini_magick', '~> 3.4'
gem 'newrelic_rpm', '~> 3.5.4.33'
gem 'port-a-query', '~> 0.1.1'
gem 'rack-cas', '~> 0.3.1'
gem 'turnout', '~> 0.2.2'
gem 'version', '~> 1.0.0'
gem 'viva-app_config', '~> 1.2.0', :require=>'app_config'
gem 'yaml_db', '~> 0.2.1'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'sqlite3-ruby', '~> 1.3.3', :require => 'sqlite3'
  gem 'pry'
  gem 'thin'
end

group :assets do
  gem 'bourbon', '~> 3.0.1'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.0.3'
  gem 'sass-rails', '~> 3.2.5'
  gem 'therubyracer', '~> 0.10.2'
end

group :staging, :production do
  gem 'mysql2', '~> 0.3.7'
end

group :production do
  gem 'exception_notification', '~> 3.0.0'
end