# Extends your user model (the models that calls acts_as_authentic) 
module AuthlogicNetID

  module ActsAsAuthentic
  
    def self.included(klass)
      klass.class_eval do
        extend Config
        add_acts_as_authentic_module(Methods, :prepend)
      end
    end
  
    module Config
    
      def validate_netid_login(value=nil)
        rw_config(:validate_netid_login, value, true)
      end
      alias_method(:validate_netid_login=, :validate_netid_login)
      
      def netid_login_field(value = nil)
        rw_config(:netid_login_field, value, :username)
      end
      alias_method :netid_login_field=, :netid_login_field

      def netid_password_field(value = nil)
        rw_config(:netid_password_field, value, :password)
      end
      alias_method :netid_password_field=, :netid_password_field
      
    end
    
    module Methods
    
      def self.inclued?(klass)
        klass.class_eval do
        
          attr_accessor :netid_password
          
          if validate_netid_login
            validates_uniqueness_of :netid_login, :scope => validations_scope, :if => :using_netid?
            validates_presence_of :netid_password, :if => :validate_netid?
            validate :validate_netid, :if => :validate_netid?
          end
          
        end
      end
    
      private
      def using_netid?
        responds = (respond_to?(:netid_login) && respond_to?(:netid_password))
        blank = (netid_login.blank? || netid_password.blank?)
        return responds && !blank
      end
      
      def validate_netid(password)
      
        return if errors.count > 0
      
        require 'rest_client'
        
        dirsvc = RestClient::Resource.new(
          UserSession::netid_service_uri,
          :ssl_client_key => OpenSSL::PKey::RSA.new(File.read(UserSession::ssl_key_path), UserSession::ssl_key_password),
          :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read(UserSession::ssl_cert_path)),
          :verify_ssl => OpenSSL::SSL::VERIFY_NONE
        )

        valid = (dirsvc['CheckCredentials'].post(:netid => send(netid_login_field), :password => password || send(netid_password_field)) == 'true')
        if !valid
          errors.add(:netid_login, 'invalid')
        end
        
        return valid
        
      end
    
      def validate_netid?
        netid_login_changed? && !netid_login.blank?
      end

      def netid_login_field
        self.class.netid_login_field
      end

      def netid_password_field
        self.class.netid_password_field
      end

    
    end
    
  end
  
end
