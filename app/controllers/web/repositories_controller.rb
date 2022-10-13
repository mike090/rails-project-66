# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :require_authentication

    REPOSITORY_ACTIONS = {
      check: {
        controller: 'web/repositories/checks',
        action: :create,
        pass_resource_id_as: :repository_id
      },
      refresh: {
        action: :show
      },
      show: {},
      update: {}

    }.freeze

    def index
      @repositories = policy_scope(Repository).order(created_at: :desc).decorate
      @repository_actions = REPOSITORY_ACTIONS.slice :show, :update, :check
    end

    def new
      @repository = current_user.repositories.build
      @repositories_for_select = available_repositories
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by repository_params
      if @repository.save
        UpdateRepoJob.perform_later @repository.id
        create_hook @repository.id
        redirect_to repositories_path, success: t('.success')
      else
        @repositories_for_select = available_repositories
        flash.now[:danger] = @repository.errors.full_messages_for(:github_id).join ' '
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @repository = policy_scope(Repository).find params[:id]
      @repository_actions = REPOSITORY_ACTIONS.slice :check, :refresh
      @check_actions = {
        show: {
          controller: 'web/repositories/checks'
        }
      }
    end

    def update
      @repository = policy_scope(Repository).find params[:id]
      if @repository.may_start_fetching?
        UpdateRepoJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('.success')
      else
        redirect_to repositories_path, notice: t('.fail')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def available_repositories
      traceable_repos = current_user.repositories.pluck(:github_id)
      supported_languages = Repository.enumerized_attributes[:language].values
      options = user_repos_list.reject do |repo|
        repo.id.in?(traceable_repos) || !repo.language.in?(supported_languages)
      end
      options.map do |repo|
        [repo.full_name, repo.id]
      end
    end

    def create_hook(repo_id)
      callback_url = api_checks_url
      SetRepoHookJob.perform_later repo_id, callback_url
    end

    def user_repos_list
      ApplicationContainer['remote_repositories_service'].user_repos_list(current_user.token)
    end
  end
end
