# frozen_string_literal: true

class CheckRepoJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    GithubRepoLintService.call check_id
  end
end
