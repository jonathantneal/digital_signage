class UserSession < Authlogic::Session::Base

  # These values are defined in conf/authlogic_netid.yml
  ssl_key_path AUTHLOGIC_NETID_CONFIG['ssl_key_path']
  ssl_key_password AUTHLOGIC_NETID_CONFIG['ssl_key_password']
  ssl_cert_path AUTHLOGIC_NETID_CONFIG['ssl_cert_path']
  find_by_netid_login_method :find_by_username

end
