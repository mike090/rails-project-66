# frozen_string_literal: true

class RepoCheckServiceStub
  def self.call(check_id)
    check = Repository::Check.find check_id
    check.start_checking
    check.attributes = { passed: true }
    check.complete!
  end
end
