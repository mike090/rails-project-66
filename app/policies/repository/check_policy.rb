# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    check.repository.user_id == user.id && !check.performing?
  end

  private

  def check
    @record
  end
end
