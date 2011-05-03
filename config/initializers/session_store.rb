# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_trains_session',
  :secret      => '8628c61252b52dc616e7cb9422d66a4dfe2ff06ed8dfcacbb2f85e5410352fce55713b4d0e82d920184d7318b0359fef1bd4218aa8f5d50f7d7bea322433d8a6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
