# frozen_string_literal: true

class GithubReposListService
  def self.call(access_token)
    Octokit::Client.new(access_token: access_token).repos
  end
end
