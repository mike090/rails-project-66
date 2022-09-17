# frozen_string_literal: true

class CheckRepoJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    GithubRepoCheckService.call check_id
  end
end
