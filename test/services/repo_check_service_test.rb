# frozen_string_literal: true

require 'test_helper'

class RepoCheckServiceTest < ActionDispatch::IntegrationTest
  test 'service' do
    check_repo_result = { 'commit' => 'xxxxxx', 'result' => 'dummy result', 'passed' => true }
    repo = repositories :one
    check = repo.checks.build
    check.save
    service = RepoCheckService.new nil
    service.stub :check_repo, check_repo_result do
      service.call check.id
      check.reload
      assert check.finished?
      assert { check.attributes.slice(*check_repo_result.keys) == check_repo_result }
    end
  end
end