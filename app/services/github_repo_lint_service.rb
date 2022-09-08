# frozen_string_literal: true

class GithubRepoLintService
  class << self
    def check_repo(github_id)
      repo_info = Octokit.client.repo github_id
      clone_url = repo_info.clone_url
      language = repo_info.language
      repo_path = FileUtils.mkpath(Rails.root.join("tmp/repos/#{SecureRandom.urlsafe_base64}")).first
      git = Git.clone clone_url, repo_path
      #   # stdout, stderr, status = Open3.capture3 "bundle exec rubocop #{repo_path}/ -c config/linters/.rubocop.yml -f j"
      #   { head_sha: git.object('HEAD').sha[0..6] }
      ensure
        FileUtils.rm_rf repo_path
    end
  end
end
