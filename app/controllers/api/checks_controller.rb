# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if ENV['RAILS_ENV'] == 'test'
      accept_push repository_params[:id]
      return
    end

    case request.headers['X-GitHub-Event']
    when 'ping'
      accept_ping
    when 'push'
      accept_push repository_params[:id]
    else
      render json: { '501': 'Not implemented' }, status: :not_implemented
    end
  end

  private

  def accept_push(github_id)
    repository = Repository.find_by github_id: github_id
    if repository
      check = repository.checks.new
      if check.save
        CheckRepoJob.perform_later check.id
      end
      render json: { '200': 'Ok' }, status: :ok
    else
      render json: { '404': 'Not found' }, status: :not_found
    end
  end

  def accept_ping
    render json: { '200': 'Ok', application: Rails.application.class.module_parent_name }, status: :ok
  end

  def repository_params
    params.require('repository').permit('id')
  end
end
