# frozen_string_literal: true

class RepoCheckServiceStub
  def self.call(*_args)
    { passed: true }
  end
end