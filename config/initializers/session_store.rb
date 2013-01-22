# Be sure to restart your server when you modify this file.

#SignManager::Application.config.session_store :cookie_store, :key => AppConfig.security.session.secret

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")

require 'rack-cas/session_store/rails/active_record'
SignManager::Application.config.session_store :rack_cas_active_record_store