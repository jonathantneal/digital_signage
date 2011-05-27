source 'http://rubygems.org'
source 'http://git.biola.edu/gem-repo'

gem 'rails', '3.0.7'
gem 'rake', '~> 0.8.7'

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
gem 'admin_data', :git => 'git://github.com/adamcrown/admin_data.git', :branch => 'my1.1.11' #'~>1.1.11'
gem 'biola_web_services', '~>0.1.1'
gem 'chronic', '~>0.3.0'
gem 'declarative_authorization', '~>0.5.1'
gem 'devise', '~>1.1.5'
gem 'devise_netid_authenticatable', '~>0.3.2'
# Use the following instead if using CAS:
#gem 'devise_cas_authenticatable', '~>1.0.0.alpha8'
gem 'haml', '~>3.0.22'
gem 'highline', '~>1.6.1'
gem 'httparty', '~>0.6.1'
gem 'jquery-rails', '~>0.2.6'
gem 'meta_search', '~>0.9.10'
gem 'newrelic_rpm', '~>2.13.2'
gem 'oauth', '~>0.4.3'
gem 'port-a-query', '~>0.1.0'
gem 'viva-app_config', '~>1.2.0', :require=>'app_config'
gem 'will_paginate', '~>3.0.pre2'
gem 'yaml_db', '~>0.2.0'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development do
  gem 'sqlite3-ruby', '~>1.3.2', :require => 'sqlite3'
end

group :test, :production do
  gem 'mysql', '~>2.8.1'
  gem 'ssl_requirement', '~>0.1.0'
end

group :production do  
  gem 'exception_notification', :require=>'exception_notifier', :git=>'git://github.com/rails/exception_notification'
end
