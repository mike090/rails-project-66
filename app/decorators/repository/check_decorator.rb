# frozen_string_literal: true

class Repository::CheckDecorator < ApplicationDecorator
  delegate_all

  def passed?
    return nil if result.nil?

    result.all? do |_language, result|
      result['status'] == 'check_passed'
    end
  end
end
