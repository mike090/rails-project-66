# frozen_string_literal: true

class GithubRepoInfoService
  def self.call(repository_id)
    repo = Repository.find(repository_id)
    github_id = repo.github_id
    values = repo_info(github_id)
    repo.attributes = values
    repo.end_fetching!
  rescue StandardError => e
    repo.fail_fetching! if repo.may_fail_fetching?
    raise e
  end

  def self.repo_info(github_id)
    repo_info = Octokit.client.repo(github_id).to_h.slice :id, :name, :full_name, :language
    repo_info[:github_id] = repo_info.delete :id
    repo_info
  end
end
