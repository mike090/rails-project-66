# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_check_service, RepoCheckServiceStub
    register :remote_repositories_service, AdapterStub
  else
    register :repository_check_service, -> { RepoCheckService.new GithubAdapter }
    register :remote_repositories_service, GithubAdapter
  end
end
