# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def last_check_passed
    last_check = checks.where(state: 'success').order(:updated_at).last
    return nil unless last_check

    last_check.decorate.passed?
  end
end
