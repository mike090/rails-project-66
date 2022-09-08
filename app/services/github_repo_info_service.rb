# frozen_string_literal: true

class GithubRepoInfoService
  def self.repo_info(github_id)
    Octokit.client.repo(github_id).to_h.slice :id, :name, :full_name, :language, :created_at, :updated_at
  end
end
