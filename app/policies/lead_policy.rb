class LeadPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def edit?
    user.super_user?
  end

  def update?
    user.super_user?
  end

  def destroy?
    user.super_user?
  end

  class Scope < Scope
    def resolve
      Lead.all
    end
  end
end