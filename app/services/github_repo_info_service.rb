# frozen_string_literal: true

class GithubRepoInfoService
  def self.call(github_id)
    Octokit.client.repo(github_id).to_h.slice :name, :full_name, :language
  end
end
