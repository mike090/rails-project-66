# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repo_check_service, RepoCheckServiceStub
    register :service_adapter, MockAdapter
  else
    register :repo_check_service, -> { RepoCheckService.new GithubAdapter }
    register :service_adapter, GithubAdapter
  end
end
