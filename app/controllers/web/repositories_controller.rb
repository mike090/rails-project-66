# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
    before_action :require_authentication

    def index
      @repositories = current_user.repositories
    end

    def new
      @repository = current_user.repositories.build
    end

    def create
      @repository = current_user.repositories.find_or_initialize_by repository_params
      @repository.attributes =
        (Octokit.client.repo @repository.github_id).to_h.slice :name, :full_name, :language if @repository.github_id
      if @repository.save
        redirect_to repositories_path, success: t('.success')
      else
        flash[:danger] = @repository.errors.full_messages_for(:github_id).join ' '
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @repository = Repository.find params[:id]
      redirect_to root_path, warning: t('.permission_denied') unless @repository.user_id == current_user.id
    end

    private

    def repository_params
      params.require(:repository).permit(:github_id)
    end
  end
end