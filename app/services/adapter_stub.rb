# frozen_string_literal: true

class AdapterStub
  class << self
    def repository_info(*_args)
      { name: 'repo', full_name: 'user/repo', language: 'Ruby', clone_url: 'https://github.com/user/repo.git' }
    end

    def user_repos_list(*_args)
      []
    end

    def set_repo_hook(*args); end
  end
end
