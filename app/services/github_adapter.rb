# frozen_string_literal: true

class GithubAdapter
  class << self
    def repository_info(github_id)
      Octokit.client.repo(github_id).to_h.slice :name, :full_name, :language
    end

    def user_repos_list(user_token)
      Octokit::Client.new(access_token: user_token).repos
    end

    def clone_url(github_id)
      Octokit.client.repo(github_id).clone_url
    end

    def repo_languages(github_id)
      Octokit.client.languages(github_id).to_h.keys
    end

    def set_repo_hook(github_repo_id, payload_url, access_token, *events)
      octokit_client = Octokit::Client.new access_token: access_token
      return if octokit_client.hooks(github_repo_id).any? { |hook| hook.config.url == payload_url }

      options = events.difference([:push]).empty? ? {} : { events: events, active: true }
      octokit_client.create_hook(
        github_repo_id,
        'web',
        {
          url: payload_url,
          content_type: 'json'
        },
        options
      )
    end
  end
end
