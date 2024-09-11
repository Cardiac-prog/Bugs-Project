# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
     user ||= User.new # guest user (not logged in)

    if user.manager?
      can :manage, Project  # A manager can manage all aspects of a project
    elsif user.qa?
      can :manage, Bug  # A QA can manage bugs
      can [ :read, :show ], Project do |project|
        project.qas.include?(user)  # A QA can read and update projects assigned to them
      end
    elsif user.developer?
      can :read, Project do |project|
        project.bugs.where(assigned_to: user).exists?  # Only allow reading projects with bugs assigned to the developer
      end
      can [ :read, :show, :update ], Bug do |bug|
        bug.assigned_to == user  # A developer can only read and update bugs assigned to them
      end
    end
  end
end
