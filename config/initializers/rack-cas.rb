if Rails.env.test?
  require 'rack/fake_cas'
  SignManager::Application.config.middleware.swap Rack::FakeCAS, Rack::FakeCAS
else
  require 'rack/cas'
  require 'rack-cas/session_store/active_record'

  SignManager::Application.config.middleware.use Rack::CAS,
    server_url: Settings.cas.url,
    session_store: RackCAS::ActiveRecordStore
end