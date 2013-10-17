authorization do
  role :developer do
    # has_omnipotence
    includes :admin
  end

  role :admin do
    has_permission_on [:signs, :slides, :slots, :departments, :users] do
      to :administrate
    end
    has_permission_on :signs, to: [:info, :drop_on]
    has_permission_on :slots, to: [:sort, :destroy_multiple, :destroy]
    has_permission_on :slides, to: [:destroy_multiple, :edit_multiple, :update_multiple, :add_to_signs, :drop_create]  #TODO: give managers permission to do this too, but permissions will probably have to happen in the controller.

    includes :manager
  end

  role :manager do
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

    has_permission_on :slots, :to => [:administrate, :sort, :destroy_multiple] do
      if_permitted_to :update, :sign
    end

    has_permission_on :departments, :to => :show do
      if_attribute :users => contains {user}
    end

    includes :guest
  end

  role :guest do
    has_permission_on :signs, to: [:show, :check_in, :display]
  end
end

privileges do
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
  privilege :administrate, :includes => [:create, :read, :update, :delete]
end