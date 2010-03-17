class Ability
  include CanCan::Ability

  def initialize(user)
  
    universal
  
    if !user.nil?
      can :manage, :all
    end
    
  end

  def universal
    can [:create, :destroy], UserSession
    can :show, Sign
  end
  
end
