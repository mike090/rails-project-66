# frozen_string_literal: true

class GithubSetRepoHookService
  def self.call(github_repo_id, payload_url, access_token, *events)
    octokit_client = Octokit::Client.new access_token: access_token
    return if octokit_client.hooks(github_repo_id).any? { |hook| hook.config.url == payload_url }

    options = events.difference(:push).empty? ? {} : { events: events, active: true }
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
