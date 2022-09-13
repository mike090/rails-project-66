# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def last_check_passed
    last_check = checks.where(state: 'success').order(:updated_at).last
    return last_check unless last_check

    last_check.result.all? do |_language, result|
      result['status'] == 'check_passed'
    end
  end
end
