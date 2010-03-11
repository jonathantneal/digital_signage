module AuthlogicNetID

  module ActsAsAuthentic
  
    def self.included(klass)
      klass.class_eval do
        extend Config
        add_acts_as_authentic_module(Methods, :prepend)
      end
    end
    
    module Config
    
      def netid_username_field(value = nil)
        rw_config(:netid_username_field, value, first_column_to_exist(nil, :netid, :login, :username))
      end
      alias_method :netid_username_field=, :netid_username_field

      def validate_netid_username(value = nil)
        rw_config(:validate_netid_username, value, true)
      end
      alias_method :validate_netid_username=, :validate_netid_username
    
      def find_by_netid_username(username)
        find_with_case(netid_username_field, username)
      end
    
    end
    
    module Methods
    
      def self.included(klass)
        klass.class_eval do
        
          attr_accessor :netid_password
          
          if validate_netid_username
            validates_uniqueness_of :netid_username, :scope => validations_scope, :if => :using_netid?
            validates_presence_of :netid_password, :if => :validate_netid?
            validate :validate_netid, :if => :validate_netid?
          end
          
        end
      end
      
      # TEMP
      def valid_password?(password)
        return true
      end
      
      private
      
      def using_netid?
        !netid_username.blank?
      end
      
      def validate_netid
      
        return if errors.count > 0
      
        # TODO
      
      end
      
      def validate_netid?
        netid_userame_changed? && !netid_username.blank?
      end
      
    end
    
  end
  
end
