# frozen_string_literal: true

class GithubRepoLintService
  class << self
    def check_repo(github_id)
      repo_info = Octokit.client.repo github_id
      clone_url = repo_info.clone_url
      languages = Octokit.client.languages(github_id).to_h.keys & CodeChecker.languages
      clone_path = FileUtils.mkpath(Rails.root.join("tmp/repos/#{SecureRandom.urlsafe_base64}")).first
      git = Git.clone clone_url, clone_path
      sha = git.object('HEAD').sha[0..6]
      blob_url = "#{repo_info.html_url}/blob/#{sha}"
      check_results = languages.map do |language|
        check_result = CodeChecker.check(clone_path, language)
        check_result[:errors]&.map! do |file|
          rel_path = Pathname.new(file.delete(:path)).relative_path_from(Pathname.new(clone_path))
          file[:uri] = "#{blob_url}/#{rel_path}"
          file
        end
        check_result
      end
      {
        commit_id: sha,
        check_results: check_results
      }
    ensure
      FileUtils.rm_rf clone_path
    end
  end
end
