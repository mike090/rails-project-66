# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :require_authentication

  def create
    repository = policy_scope(Repository, policy_scope_class: RepositoryPolicy::Scope).find(params[:repository_id])
    @check = repository.checks.build
    if @check.save
      CheckRepoJob.perform_later @check.id
      redirect_to repository_path(params[:repository_id]), success: t('.success')
    else
      @check.fail!
      redirect_back fallback_location: repositories_path, success: t('.fail')
    end
  end

  def show
    @check = Repository::Check.find params[:id]
    authorize(@check)
  end
end
