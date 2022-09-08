# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  def create
    @check = Repository.find(params[:repository_id]).checks.build
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
  end
end
