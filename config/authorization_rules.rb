authorization do

  role :admin do
  
    has_permission_on [:announcements, :documents, :users] do
      to :administrate
    end
    
    has_permission_on :signs do
      to :administrate
    end
    
    has_permission_on :info do
      to :performance, :database, :config, :reload_config, :appinfo
    end
    
    includes :manager
    
  end
  
  role :manager do
    
    has_permission_on :dashboard do
      to :read
    end
    
    has_permission_on :announcements do
      to :read
      if_attribute :show? => is {true}
    end
    
    has_permission_on :users do
      to :show
      if_attribute :id => is {user.id}
    end
   
    has_permission_on :signs do
      to :read
    end
    
    has_permission_on :slides do
      to :administrate
    end
    
    has_permission_on :slots do
      to :administrate, :sort
    end
    
    includes :guest
    
  end
  
  role :guest do
  
    has_permission_on :pages do
      to :feedback
    end
  
    has_permission_on :documents do
      to :read
    end
    
    has_permission_on :info do
      to :appinfo
    end
    
    has_permission_on :signs do
      to :show, :check_in
    end
    
  end
  
end

privileges do
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
  privilege :administrate, :includes => [:create, :read, :update, :delete, :auto_update]
end
