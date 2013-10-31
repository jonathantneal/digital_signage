authorization do
  role :developer do
    includes :admin

    has_permission_on :users, to: [:impersonate]
  end

  role :admin do
    includes :user

    has_permission_on [:departments, :users, :signs], to: [:administrate]
  end

  role :employee do
    includes :user
  end

  role :student do
    includes :user
  end





  ####################   General Roles (Only included above)   ################
  ## Caution: The roles 'department_owner' and 'department_editor' are in no way exclusive. Everyone
  ##  is a potential owner or editor, so be sure to limit each permission by
  ##  collaboration. Don't just give an 'owner' free access to something,
  ##  because a 'viewer' will unintentionally get the same free access.
  #############################################################################

  # User is the primary role for assigning permissions to logged in users.
  #    Maybe one day we will actually give users this role.
  #    For now it is inherited by the roles above.
  role :user do
    includes :guest
    includes :department_user

    # Actions that any user can do no matter department permissions
    has_permission_on :users, to: :show do
      if_attribute id: is {user.id}
    end
    has_permission_on [:signs, :slides], to: [:read]
  end

  # Permissions for users who are in a given department
  role :department_user do
    has_permission_on :slots, to: [:administrate, :sort] do
      if_attribute department: { users: contains {user} }
    end

    has_permission_on :signs, to: [:edit_slots, :sort, :drop_on] do
      if_attribute department: { users: contains {user} }
    end

    has_permission_on :slides, to: [:create, :fork, :edit_multiple, :update_multiple, :destroy_multiple, :add_to_signs, :drop_create] # per slide permissions will have to happen in the controller
    has_permission_on :slides, to: [:edit, :update, :destroy] do
      if_attribute department: { users: contains {user} }
    end

    has_permission_on :departments, to: :show do
      if_attribute users: contains {user}
    end
  end


  # The 'guest' role is applied to everyone, including anonymous users.
  role :guest do
    has_permission_on :signs, to: [:show, :check_in, :display]
    has_permission_on :slides, to: [:show_editable_content]
  end
end

privileges do
  privilege :create, :includes => :new
  privilege :read, :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
  privilege :administrate, :includes => [:create, :read, :update, :delete]
end