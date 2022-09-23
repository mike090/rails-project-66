# frozen_string_literal: true

class GitCloneService
  def self.call(clone_url)
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
