# frozen_string_literal: true

class MockAdapter
  class << self
    def repository_info(*_args)
      { name: 'repo', full_name: 'user/urepo', language: 'Ruby' }
    end

    def user_repos_list(*_args)
      []
    end

    def set_repo_hook(*args); end
  end
end
