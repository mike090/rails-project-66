# frozen_string_literal: true

class GithubRepoInfoService
  def self.repo_info(github_id)
    repo_info = Octokit.client.repo(github_id).to_h.slice :id, :name, :full_name, :language
    repo_info[:github_id] = repo_info.delete :id
    repo_info
  end
end
