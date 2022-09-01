# frozen_string_literal: true

module RepositoryCheckerApi

  class RubocopLintError < StandardError; end

  def self.download_repo(clone_url, dir)
    Git.clone repo_info.git_url, dir
  end

  def self.ruby_lint(dir)
    result = Open3.capture3 "rubocop -c .rubocop.yml -f j"
    raise RubocopLintError, result.second.lines.first if result.last.exitstatus == 2

    result
  end

  def self.ruby_check_repo(clone_url)
    begin
      tmp_path = Rails.root.join("tmp/repos_cheks/#{SecureRandom.urlsafe_base64}")
      FileUtils.mkpath tmp_path
      Git.clone clone_url, tmp_path
      Dir.chdir tmp_path
      ruby_lint tmp_path
    ensure
      Dir.chdir Rails.root
      FileUtils.remove_entry tmp_path
    end
  end

  def self.check_repo(repo_id)
    begin
      repo = Repository.find repo_id
      repo_info = Octokit.client.repo repo.github_id
      check_result = ruby_check_repo repo_info.clone_url
      check_status = [:finished_success, :finished_with_errors][check_result.last.exitstatus]
      { repo_id: repo_id, result: check_status, raw: JSON.parse(check_result.first) }
    rescue StandardError => e
      { repo_id: repo_id, result: :check_fail, error: "#{e.class}: '#{e.message}'"}
    end
  end

end
