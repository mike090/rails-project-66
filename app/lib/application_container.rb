# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repo_check_service, RepoCheckServiceStub
    register :remote_service, AdapterStub
  else
    register :repo_check_service, -> { RepoCheckService.new GithubAdapter }
    register :remote_service, GithubAdapter
  end
end
