source 'http://rubygems.org'
source 'https://gems.biola.edu'

gem 'rails', '3.2.8'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
gem 'action_links', '~> 0.3.0'
gem 'addressable', '~>2.2.6'
gem 'appinfo', '~>0.1.0'
gem 'carrierwave', '~>0.6.2'
gem 'chronic', '~>0.6.2'
gem 'daemons', '~>1.1.9'
gem 'declarative_authorization', '~>0.5.3'
gem 'devise', '~> 2.1.2'
gem 'devise_cas_authenticatable', '~> 1.1.2'
gem 'haml', '~>3.1.7'
gem 'highline', '~>1.6.2'
gem 'httparty', '~>0.7.8'
gem 'jquery-rails', '~>2.1.1'
gem 'jquery-ui-rails', '~>2.0.0'
gem 'jquery-ui-themes', '~> 0.0.7'
gem 'kaminari', '~>0.13.0'
gem 'memoist', '~> 0.2.0'
gem 'meta_search', '~>1.1.1'
gem 'mini_magick', '~>3.4'
gem 'newrelic_rpm', '~>3.3.4'
gem 'oauth', '~>0.4.3'
gem 'port-a-query', '~>0.1.1'
gem 'turnout', '~>0.2.2'
gem 'version', '~> 1.0.0'
gem 'viva-app_config', '~>1.2.0', :require=>'app_config'
gem 'yaml_db', '~>0.2.1'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'sqlite3-ruby', '~>1.3.3', :require => 'sqlite3'
  gem 'pry'
  gem 'thin'
end

group :assets do
  gem 'bourbon', '~> 2.1.0'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'compass-rails', '~> 1.0.3'
  gem 'sass-rails', '~> 3.2.5'
  gem 'therubyracer', '~> 0.10.2'
end

group :staging, :production do
  gem 'mysql2', '~>0.3.7'
end

group :production do  
  gem 'exception_notification', :require=>'exception_notifier', :git=>'git://github.com/rails/exception_notification'
end
