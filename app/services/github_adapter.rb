# frozen_string_literal: true

class GithubAdapter
  class << self
    def repository_info(github_id)
      Octokit.client.repo(github_id).to_h.slice :name, :full_name, :language, :clone_url
    end

    def user_repos_list(user_token)
      Octokit::Client.new(access_token: user_token).repos auto_paginate: true
    end

    def clone_url(github_id)
      Octokit.client.repo(github_id).clone_url
    end

    def repo_languages(github_id)
      Octokit.client.languages(github_id).to_h.keys
    end

    def set_repo_hook(repo_id, payload_url)
      repo = Repository.find repo_id
      octokit_client = Octokit::Client.new access_token: repo.user.token
      return if octokit_client.hooks(repo.github_id).any? { |hook| hook.config.url == payload_url }

      octokit_client.create_hook(
        repo.github_id,
        'web',
        {
          url: payload_url,
          content_type: 'json'
        }
      )
    end
  end
end
