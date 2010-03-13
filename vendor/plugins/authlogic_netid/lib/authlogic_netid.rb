require 'authlogic_netid/acts_as_authentic'
require 'authlogic_netid/session'

if ActiveRecord::Base.respond_to?(:add_acts_as_authentic_module)
  ActiveRecord::Base.send(:include, AuthlogicNetID::ActsAsAuthentic)
  Authlogic::Session::Base.send(:include, AuthlogicNetID::Session)
end
