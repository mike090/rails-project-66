# frozen_string_literal: true

class RepoInfoServiceStub
  def self.call(*_args)
    { name: 'repo', full_name: 'user/urepo', language: 'Ruby' }
  end
end
