# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
     user ||= User.new # guest user (not logged in)

    if user.manager?
      can :manage, Project, manager_id: user.id  # A manager can manage all aspects of a project
    elsif user.qa?
      can :manage, Bug, reported_by_id: user.id  # QA can only manage bugs reported by them
      can [ :read, :show ], Project, qas: { id: user.id }  # QA can read only their assigned projects

    elsif user.developer?
      can :read, Project, bugs: { assigned_to: user }         # can read only those projects that have bugs assigned to the developer
      can [ :read, :show, :update ], Bug, assigned_to: user
    end
  end
end
