# frozen_string_literal: true

class RepoUpdateJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    GithubRepoInfoService.call repository_id
    Rails.logger.info "Repository id# #{repository_id} info successfly updated"
  rescue StandardError => e
    Rails.logger.error "Error during fetching repository information: #{e}"
  end
end
