# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    check.repository.user_id == user.id
  end

  private

  def check
    @record
  end
end
