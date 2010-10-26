# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  config.gem 'authlogic', :version => '~>2.1.6'
  config.gem 'cancan', :version => '~>1.3.4'
  config.gem 'chronic', :version => '~>0.3.0'
  config.gem 'haml', :version => '~>3.0.22'
  config.gem 'highline', :version => '~>1.6.1'
  config.gem 'jrails', :version => '~>0.6.0'
  config.gem 'mysql', :version => '~>2.8.1'
  config.gem 'searchlogic', :version => '~>2.4.27'
  config.gem 'tickle', :version => '~>0.1.7'
  config.gem 'ssl_requirement', :version => '~>0.1.0'
  config.gem 'will_paginate', :version => '~>2.3.14'

  config.time_zone = 'Pacific Time (US & Canada)'

end
