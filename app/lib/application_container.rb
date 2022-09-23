# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repo_check_service, RepoCheckServiceStub
    register :repo_info_service, RepoInfoServiceStub
    register :set_repo_hook_service, SetHookServiceStub
    register :user_repos_list_service, UserReposListServiceStub
  else
    register :repo_check_service, GithubRepoCheckService
    register :repo_info_service, GithubRepoInfoService
    register :set_repo_hook_service, GithubSetRepoHookService
    register :user_repos_list_service, GithubReposListService
  end
end
