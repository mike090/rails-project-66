# frozen_string_literal: true

class SetRepoHookJob < ApplicationJob
  queue_as :default

  def perform(github_repo_id, payload_url, access_token, *events)
    ApplicationContainer['set_repo_hook_service'].call github_repo_id, payload_url, access_token, *events
    Rails.logger.info "Webhook for Github repo id: #{github_repo_id} successfly setted"
  rescue StandardError => e
    Rails.logger.error "Github repo id: #{github_repo_id} webhook setting error: #{e.class} - #{e.message}"
  end
end
