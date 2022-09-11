# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :require_authentication

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = current_user.repositories.build
      @repositories_select_list = available_repositories
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by repository_params
      if @repository.save
        @repository.start_fetching!
        RepoUpdateJob.perform_later @repository.id
        redirect_to repositories_path, success: t('.success')
      else
        flash[:danger] = @repository.errors.full_messages_for(:github_id).join ' '
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @repository = ::Repository.find params[:id]
      redirect_to root_path, warning: t('.permission_denied') unless @repository.user_id == current_user.id
    end

    def update
      @repository = Repository.find params[:id]
      if @repository.may_start_fetching?
        @repository.start_fetching!
        RepoUpdateJob.perform_later(@repository.id)
        redirect_to repositories_path, notice: t('success')
      else
        redirect_to repositories_path, notice: t('fail')
      end
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end

    def available_repositories
      traceable_repos = current_user.repositories.pluck(:github_id)
      supported_languages = Repository.enumerized_attributes[:language].values
      options = Octokit.client.repos.reject do |repo|
        repo.id.in?(traceable_repos) || !repo.language.in?(supported_languages)
      end
      options.map do |repo|
        [repo.full_name, repo.id]
      end
    end
  end
end
