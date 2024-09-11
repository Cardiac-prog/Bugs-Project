# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
     user ||= User.new # guest user (not logged in)

    if user.manager?
      can :manage, Project  # A manager can manage all aspects of a project
    elsif user.qa?
      can :manage, Bug  # A QA can manage bugs
      can [ :read, :show ], Project, qas: { id: user.id }    # can see only associated projects

    elsif user.developer?
      can :read, Project, bugs: { assigned_to: user }         # can read only those projects that have bugs assigned to the developer
      can [ :read, :show, :update ], Bug, assigned_to: user
    end
  end
end
