# frozen_string_literal: true

class RepositoryDecorator < ApplicationDecorator
  delegate_all

  def last_check_passed
    last_check = checks.finished.order(:updated_at).last
    last_check&.passed?
  end
end
