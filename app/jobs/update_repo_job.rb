# frozen_string_literal: true

class UpdateRepoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repo = Repository.find(repository_id)
    repo.transaction do
      update_values = ApplicationContainer['repo_info_service'].call repo.github_id
      repo.attributes = update_values if update_values
      repo.end_fetching
      repo.save!
    end
    Rails.logger.info "Repository id# #{repository_id} info successfly updated"
  rescue StandardError => e
    Rails.logger.error "Error during fetching repository information: #{e}"
  end
end
