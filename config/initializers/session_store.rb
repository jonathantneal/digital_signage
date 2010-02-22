# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_sign-manager_session',
  :secret      => 'fbcbbd1e274514002aa080f419f4db5ec514c07ceba630134a13f1c3b18093bc5eebeb942b4abf48be758018cea0aa928947c5a7ed5ce6743c771e0f9332af0e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
