authorization do

  role :developer do
  
    has_omnipotence
    
  end
  
  role :admin do
    has_permission_on [:announcements, :documents, :users] do
      to :administrate
    end
    
    has_permission_on [:signs, :slides, :slots, :departments] do
      to :administrate
    end
    has_permission_on :slots, :to => :sort
    
    includes :manager
  end
  
  role :manager do
    
    has_permission_on :dashboard do
      to :read
    end
    
    has_permission_on :announcements, :to => :read do
      if_attribute :show? => is {true}
    end
    
    has_permission_on :users, :to => :show do
      if_attribute :id => is {user.id}
    end
   
    has_permission_on :signs, :to => [:read, :update, :check_in] do
      if_permitted_to :show, :department
    end
    
    has_permission_on :slides, :to => [:read, :create]
    has_permission_on :slides, :to => :update do
      if_permitted_to :show, :department
    end
    
    has_permission_on :slots, :to => [:administrate, :sort] do
      if_permitted_to :update, :sign
    end
    
    has_permission_on :departments, :to => :show do
      if_attribute :users => contains {user}
    end
    
    includes :guest
    
  end
  
  role :guest do
  
    has_permission_on :signs do
      to :show, :check_in
    end
  
    has_permission_on :pages do
      to :feedback
    end
  
    has_permission_on :documents do
      to :read
    end
    
    has_permission_on :info do
      to :appinfo
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
