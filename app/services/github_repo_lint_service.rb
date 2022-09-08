# frozen_string_literal: true

class GithubRepoLintService
  class << self
    def check_repo(github_id)
      byebug
      repo_info = Octokit.client.repo github_id
      clone_url = repo_info.clone_url
      languages = Octokit.client.languages(github_id).to_h.keys & CodeChecker.languages
      Dir.mktmpdir('hexlet_quality') do |clone_path|
        git = Git.clone clone_url, clone_path
        sha = git.object('HEAD').sha[0..6]
        check_results = languages.map do |language|
          check_result = CodeChecker.check(clone_path, language)
          check_result[:errors]&.map! do |file|
            file[:blob_path] = Pathname.new(file.delete(:path)).relative_path_from(Pathname.new(clone_path)).to_s
            file
          end
          check_result
        end
        {
          commit_id: sha,
          check_results: check_results
        }
      end
    end
  end
end
