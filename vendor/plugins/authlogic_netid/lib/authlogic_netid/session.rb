module AuthlogicNetID

  module Session

    def self.included(klass)
      klass.class_eval do
        extend Config
        include Methods
        
        verify_password_method :validate_netid
        
      end
    end

    module Config

      def netid_service_uri(value = nil)
        rw_config(:netid_service_uri, value, 'https://ws.biola.edu/dirsvc/rest')
      end
      alias_method :netid_service_uri=, :netid_service_uri

      #def netid_service_user_exists_call(value = nil)
      #  rw_config(:netid_service_user_exists_call, value, 'UserExists')
      #end
      #alias_method :netid_service_user_exists_call=, :netid_service_user_exists_call

      #def netid_service_authenticate_call(value = nil)
      #  rw_config(:netid_service_authenticate_call, value, 'CheckCredentials')
      #end
      #alias_method :netid_service_authenticate_call=, :netid_service_authenticate_call

      def ssl_key_path(value = nil)
        rw_config(:ssl_key_path, value, '/tmp/netid.pem')
      end
      alias_method :ssl_key_path=, :ssl_key_path

      def ssl_key_password(value = nil)
        rw_config(:ssl_key_password, value, '')
      end
      alias_method :ssl_key_password=, :ssl_key_password

      def ssl_cert_path(value = nil)
        rw_config(:ssl_cert_path, value, '/tmp/netid.pem')
      end
      alias_method :ssl_cert_path=, :ssl_cert_path

      def verify_ssl(value = nil)
        rw_config(:verify_ssl, value, false)
      end
      alias_method :verify_ssl=, :verify_ssl

      def find_by_netid_login_method(value = nil)
        rw_config(:find_by_netid_login_method, value, :find_by_netid_login)
      end
      alias_method :find_by_netid_login_method=, :find_by_netid_login_method

    end

    module Methods

      def self.included(klass)
        klass.class_eval do
          attr_accessor :netid_login
          attr_accessor :netid_password
          validate :validate_by_netid, :if => :authenticating_with_netid?
        end
      end

      # Hooks into credentials to print out meaningful credentials for NetID authentication
      def credentials
        if authenticating_with_netid?
          details = {}
          details[:netid_login] = send(login_field)
          details[:netid_password] = '<protected>'
          return details
        else
          super
        end
      end

      # Hooks into credentials so that you can pass an :netid_login and :netid_password key
      def credentials=(value)
        super
        values = value.is_a?(Array) ? value : [value]
        hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
        if !hash.nil?
          self.netid_login = hash[:netid_login] if hash.key?(:netid_login)
          self.netid_password = hash[:netid_password] if hash.key?(:netid_password)
        end
      end

      private
      def authenticating_with_netid?
        !netid_service_uri.blank? && (!netid_login.blank? || !netid_password.blank?)
      end

      def validate_by_netid
      
        errors.add(:netid_login, 'can not be blank') if netid_login.blank?
        errors.add(:netid_password, 'can not be blank') if netid_password.blank?
        return if errors.count > 0

        require 'rest_client'
        
        dirsvc = RestClient::Resource.new(
          netid_service_uri,
          :ssl_client_key => OpenSSL::PKey::RSA.new(File.read(ssl_key_path), ssl_key_password),
          :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read(ssl_cert_path)),
          :verify_ssl => false
        )

        valid = (dirsvc['CheckCredentials'].post(:netid => netid_login, :password => netid_password) == 'true')

        if valid
          self.attempted_record = search_for_record(find_by_netid_login_method, netid_login)
          errors.add(:netid_login, 'does not exist') if self.attempted_record.blank?
        else
          errors.add(:netid_login, 'invalid')
        end
        
        return valid
        
      end

      def netid_service_uri
        self.class.netid_service_uri
      end

      #def netid_service_user_exists_call
      #  self.class.netid_service_user_exists_call
      #end

      #def netid_service_authenticate_call
      #  self.class.netid_service_authenticate_call
      #end

      def ssl_key_path
        self.class.ssl_key_path
      end

      def ssl_key_password
        self.class.ssl_key_password
      end

      def ssl_cert_path
        self.class.ssl_cert_path
      end

      def verify_ssl
        self.class.verify_ssl
      end

      def find_by_netid_login_method
        self.class.find_by_netid_login_method
      end

    end

  end

end
