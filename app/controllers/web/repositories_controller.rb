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
      @repositories = policy_scope(Repository).decorate
      @repository_actions = REPOSITORY_ACTIONS.slice :show, :update, :check
    end

    def new
      @repository = current_user.repositories.build
      @repositories_select_list = available_repositories
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by repository_params
      if @repository.save
        @repository.start_fetching!
        UpdateRepoJob.perform_later @repository.id
        create_github_hook @repository.github_id
        redirect_to repositories_path, success: t('.success')
      else
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
        @repository.start_fetching!
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
      options = octokit_client.repos.reject do |repo|
        repo.id.in?(traceable_repos) || !repo.language.in?(supported_languages)
      end
      options.map do |repo|
        [repo.full_name, repo.id]
      end
    end

    def create_github_hook(github_id)
      if request.host.in? %w[localhost 127.0.0.1 0.0.0.0]
        Rails.logger.debug 'set webhook to localhost prevented'
        return
      end
      callback_url = api_checks_url
      SetGuthubHookJob.perform_later github_id, callback_url, current_user.token
    end

    def octokit_client
      @octokit_client ||= Octokit::Client.new access_token: current_user.token
    end
  end
end
