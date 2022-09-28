# frozen_string_literal: true

class RepoCheckService
  def initialize(remote_service_adapter)
    @service_adapter = remote_service_adapter
  end

  def call(repo_id, clone_url: nil)
    clone_url ||= @service_adapter.clone_url(repo_id)
    languages = @service_adapter.repo_languages(repo_id) & CodeChecker.languages

    GitCloneService.call(clone_url) do |git|
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
end
