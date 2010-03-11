module AuthlogicNetID

  module Session

    def self.included(klass)
      klass.class_eval do
      
        extend Config
        include InstanceMethods
        
        validate :validate_by_netid, :if => :authenticating_with_netid?
        
        class << self
          attr_accessor :configured_netid_password_methods
        end
        
      end
    end

    module Config

      def netid_service_uri(value = nil)
        rw_config(:netid_service_uri, value, 'https://ws.biola.edu/dirsvc/rest')
      end
      alias_method :netid_service_uri=, :netid_service_uri

      def netid_service_user_exists_call(value = nil)
        rw_config(:netid_service_user_exists_call, value, 'UserExists')
      end
      alias_method :netid_service_user_exists_call=, :netid_service_user_exists_call

      def netid_service_authenticate_call(value = nil)
        rw_config(:netid_service_authenticate_call, value, 'CheckCredentials')
      end
      alias_method :netid_service_authenticate_call=, :netid_service_authenticate_call

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

      def netid_username_field(value = nil)
        rw_config(:netid_username_field, value, :username)
      end
      alias_method :netid_username_field=, :netid_username_field

      def netid_password_field(value = nil)
        rw_config(:netid_password_field, value, :password)
      end
      alias_method :netid_password_field=, :netid_password_field

      def find_by_netid_username_method(value = nil)
        rw_config(:find_by_netid_username_method, value, :find_by_netid_username)
      end
      alias_method :find_by_netid_username_method=, :find_by_netid_username_method

      def netid_search_local_database_first(value = nil)
        rw_config(:netid_serch_local_database_first, value, false)
      end
      alias_method :netid_search_local_database_first=, :netid_search_local_database_first
      
      def netid_create_in_database(value = nil)
        rw_config(:netid_create_in_database, value, false)
      end
      alias_method :netid_create_in_database=, :netid_create_in_database

      def create_with_netid_data_method(value = nil)
        rw_config(:create_with_netid_data_method, value, :create_with_netid_data)
      end
      alias_method :create_with_netid_data_method=, :create_with_netid_data_method

    end

    module InstanceMethods

      def initialize(*args)
      
        if !self.class.configured_netid_password_methods
        
          if netid_username_field
            self.class.send(:attr_writer, netid_username_field) if !respond_to?("#{netid_username_field}=")
            self.class.send(:attr_reader, netid_username_field) if !respond_to?(netid_username_field)
          end
          
          if netid_password_field
          
            self.class.send(:attr_writer, netid_password_field) if !respond_to?("#{netid_password_field}=")
            self.class.send(:define_method, netid_password_field) {} if !respond_to?(netid_password_field)
            
            klass.class_eval <<-"end_eval", __FILE__, __LINE__
              private
              def protected_#{netid_password_field}
                @#{netid_password_field}
              end
            end_eval
            
          end
          
          self.class.configured_netid_password_methods = true
          
        end      
      
        super
        
      end

      def credentials
        if authenticating_with_netid?
          details = {}
          details[netid_username_field.to_sym] = send(netid_username_field)
          details[netid_password_field.to_sym] = "<protected>"
          details
        else
          super
        end
      end

      def credentials=(value)
        super
        values = value.is_a?(Array) ? value : [value]
        hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
        if !hash.nil?
          hash.slice(netid_username_field, netid_password_field).each do |field,value|
            next if value.blank?
            send("#{field}=", value)
          end
        end
      end

      private

      def authenticating_with_netid?
        (!send(netid_username_field).blank? || !send(netid_password_field).blank?)
      end

      def validate_by_netid

        require 'rest_client'

        return if netid_search_local_database_first && errors.count == 0 && !self.attempted_record.blank?

        errors.clear
        errors.add(netid_username_field, "can not be blank") if netid_username_field.blank?
        errors.add(netid_password_field, "can not be blank") if netid_password_field.blank?
        return false if errors.count > 0 

        dirsvc = RestClient::Resource.new(
          netid_service_uri,
          :ssl_client_key => OpenSSL::PKey::RSA.new(File.read(ssl_key_path), ssl_key_password),
          :ssl_client_cert  =>  OpenSSL::X509::Certificate.new(File.read(ssl_cert_path)),
          :verify_ssl       =>  OpenSSL::SSL::VERIFY_NONE
        )

        is_valid_netid = (dirsvc['UserExists'].post(:netid => send(netid_username_field)) == 'true')
        if is_valid_netid
          is_valid_password = (dirsvc['CheckCredentials'].post(:netid => send(netid_username_field), :password => send("protected_#{netid_password_field}")) == 'true')
          if is_valid_password
            self.attempted_record = search_for_record(find_by_netid_username_method, send(netid_username_field))
          end
        end

        errors.add("NetID") if !is_valid_netid
        errors.add("Password") if !is_valid_password

      end

      def fetch_user_data(username, password)
        # TODO
      end

      def netid_service_uri
        self.class.netid_service_uri
      end

      def netid_service_user_exists_call
        self.class.netid_service_user_exists_call
      end

      def netid_service_authenticate_call
        self.class.netid_service_authenticate_call
      end

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

      def netid_username_field
        self.class.netid_username_field
      end

      def netid_password_field
        self.class.netid_password_field
      end

      def find_by_netid_username_method
        self.class.find_by_netid_username_method
      end

      def netid_search_local_database_first
        self.class.netid_search_local_database_first
      end
      
      def netid_create_in_database
        self.class.netid_create_in_database
      end

      def create_with_netid_data_method
        self.class.create_with_netid_data_method
      end

    end

  end

end
