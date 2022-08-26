# frozen_string_literal: true

module ApplicationHelper
  def repository_select_options
    traceable_repos = current_user.repositories.pluck(:github_id)
    supported_languages = Repository.enumerized_attributes[:language].values
    options = octokit_client.repos.reject do |repo|
      repo.id.in?(traceable_repos) || !repo.language.in?(supported_languages)
    end
    options.map do |repo|
      [repo.full_name, repo.id]
    end
  end

  def octokit_client
    @octokit_client ||= Octokit::Client.new access_token: current_user.token, auto_paginate: false
  end
end
