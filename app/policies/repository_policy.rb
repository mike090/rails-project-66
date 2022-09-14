# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  # we need all these policies to make method “allow?” working
  def show?
    true
  end

  def check?
    true
  end

  def update?
    @record.may_start_fetching?
  end

  def refresh?
    show?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user_id: user.id)
    end

    private

    attr_reader :user, :scope
  end
end
