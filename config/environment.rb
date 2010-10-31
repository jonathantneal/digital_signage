# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'biola_web_services', :version=>'~>0.1.1', :source=>'http://git.biola.edu/gem-repo'
  config.gem 'chronic', :version=>'~>0.3.0'
  config.gem 'declarative_authorization', :version=>'~>0.5.1'
  config.gem 'devise', :version=>'~>1.0.8'
  config.gem 'devise_netid_authenticatable', :version=>'~>0.1.1', :source=>'http://git.biola.edu/gem-repo'
  config.gem 'exception_notification', :version=>'~>1.0.20090728'
  config.gem 'haml', :version=>'~>3.0.22'
  config.gem 'highline', :version=>'~>1.6.1'
  config.gem 'httparty', :version=>'~>0.6.1'
  config.gem 'jrails', :version=>'~>0.6.0'
  config.gem 'mysql', :version=>'~>2.8.1'
  config.gem 'newrelic_rpm', :version=>'~>2.13.2'
  config.gem 'oauth', :version=>'~>0.4.3'
  config.gem 'port-a-query', :version=>'~>0.1.0'
  config.gem 'searchlogic', :version=>'~>2.4.27'
  config.gem 'ssl_requirement', :version=>'~>0.1.0'
  config.gem 'viva-app_config', :lib=>'app_config', :version=>'~>1.2.0'
  config.gem 'will_paginate', :version=>'~>2.3.14'
  config.gem 'yaml_db', :version=>'~>0.1.0'

  # Only load the plugins named here, in the order given (default is alphabetical).
  config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Pacific Time (US & Canada)'

end
