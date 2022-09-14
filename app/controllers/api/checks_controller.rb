# frozen_string_literal: true

module Api
  class ChecksController < ApplicationController
    def create
      repository = Repository.find_by github_id: params['repository']['id']
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
  end
end
