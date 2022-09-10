# frozen_string_literal: true

class GithubRepoLintService
  class << self
    def call(check_id)
      check = Repository::Check.find check_id
      github_id = check.repository.github_id
      check_result = check_repo github_id
      check.reload
      if check.may_complete?
        check.attributes = check_result
        check.complete!
      end
    rescue StandardError => e
      check.reload
      check.fail! if check.may_fail?
      raise e
    end

    def check_repo(github_id)
      repo_info = Octokit.client.repo github_id
      clone_url = repo_info.clone_url
      languages = Octokit.client.languages(github_id).to_h.keys & CodeChecker.languages
      Dir.mktmpdir('hexlet_quality') do |clone_path|
        git = Git.clone clone_url, clone_path
        sha = git.object('HEAD').sha[0..6]
        check_results = languages.to_h do |language|
          check_result = CodeChecker.check(clone_path, language)
          check_result[:errors]&.map! do |file|
            file[:blob_path] = Pathname.new(file.delete(:path)).relative_path_from(Pathname.new(clone_path)).to_s
            file
          end
          [language, check_result]
        end
        {
          commit: sha,
          result: check_results
        }
      end
    end
  end
end
