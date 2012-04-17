BiolaWebServices.configure do |config|
  config.url          = AppConfig.security.url
  config.cert_path    = AppConfig.security.cert_path
  config.key_path     = AppConfig.security.key_path
  config.key_password = AppConfig.security.key_password
  config.verify_ssl   = AppConfig.security.verify_ssl
  config.ssl_version  = AppConfig.security.ssl_version
end