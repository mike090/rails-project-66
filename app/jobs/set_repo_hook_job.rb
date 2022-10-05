# frozen_string_literal: true

class SetRepoHookJob < ApplicationJob
  queue_as :default

  def perform(repo_id, payload_url, *events)
    ApplicationContainer['remote_service'].set_repo_hook repo_id, payload_url, *events
    Rails.logger.info "Webhook for repo id: #{repo_id} successfly setted"
  rescue StandardError => e
    Rails.logger.error "Repo id: #{repo_id} webhook setting error: #{e.class} - #{e.message}"
  end
end
