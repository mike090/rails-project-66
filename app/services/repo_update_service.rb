# frozen_string_literal: true

class RepoUpdateService
  class << self
    def call(repository_id)
      repo = Repository.find(repository_id)
      return unless repo.may_start_fetching?

      begin
        repo.start_fetching!
        repo.attributes = remote_repositories_service.repository_info repo.github_id
        repo.end_fetching!
      rescue StandardError => e
        repo.fail_fetching!
        raise e
      end
    end

    private

    def remote_repositories_service
      ApplicationContainer['remote_repositories_service']
    end
  end
end
