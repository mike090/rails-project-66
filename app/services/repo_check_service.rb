# frozen_string_literal: true

class RepoCheckService
  def initialize(remote_repositories_service)
    @remote_repositories_service = remote_repositories_service
  end

  def call(check_id)
    check = Repository::Check.find check_id
    check.start_checking!

    begin
      check.attributes = check_repo check.repository
      check.complete!
    rescue StandardError => e
      if check
        check.result = "#{e.class}: #{e.message}"
        check.fail!
      end
      raise e
    end
  end

  private

  def check_repo(repo)
    languages = @remote_repositories_service.repo_languages(repo.github_id) & CodeChecker.languages

    clone_path = Dir.mktmpdir
    begin
      clone_url = repo.clone_url || @remote_repositories_service.clone_url(repo.github_id)
      git = Git.clone clone_url, clone_path
      clone_path = git.dir.path
      check_results = languages.to_h do |language|
        check_result = CodeChecker.check(clone_path, language)
        check_result[:errors]&.map! do |file|
          file[:blob_path] = Pathname.new(file.delete(:path)).relative_path_from(Pathname.new(clone_path)).to_s
          file
        end
        [language, check_result]
      end
      {
        commit: git.object('HEAD').sha[0..6],
        result: check_results,
        passed: check_results.all? { |_language, result| result['status'] == 'check_passed' }
      }
    ensure
      FileUtils.remove_entry clone_path
    end
  end
end
