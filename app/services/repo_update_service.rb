# frozen_string_literal: true

class RepoUpdateService
  class << self
    def call(repository_id)
      repo = Repository.find(repository_id)
      return unless repo.may_start_fetching?

      begin
        repo.start_fetching!
        update_values = remote_service.repository_info repo.github_id
        repo.attributes = update_values if update_values
        repo.end_fetching!
      rescue StandardError => e
        repo.fail_fetching!
        raise e
      end
    end

    private

    def remote_service
      ApplicationContainer['remote_service']
    end
  end
end
