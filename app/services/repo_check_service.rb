# frozen_string_literal: true

class RepoCheckService
  def initialize(remote_service)
    @remote_service = remote_service
  end

  def call(check_id)
    check = Repository::Check.find check_id
    return unless check.checking?

    begin
      update_values = check_repo check.repository
      check.attributes = update_values if update_values
      check.complete!
    rescue StandardError => e
      check.result = "#{e.class}: #{e.message}"
      check.fail!
      raise e
    end
  end

  private

  def check_repo(repo)
    languages = @remote_service.repo_languages(repo.github_id) & CodeChecker.languages

    clone_repository(repo.clone_url) do |git|
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
    end
  end

  def clone_repository(clone_url)
    clone_path = Dir.mktmpdir
    git = Git.clone clone_url, clone_path
    if block_given?
      result = yield git
      FileUtils.remove_entry clone_path
      result
    else
      git
    end
  rescue StandardError
    FileUtils.remove_entry clone_path
  end
end
