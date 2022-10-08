# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'create new check' do
    repository = repositories(:without_checks)
    post api_checks_path, params: { repository: { id: repository.github_id } }, headers: { 'X-GitHub-Event' => 'push' }
    check = repository.checks.last
    assert { check.finished? }
    assert_response :success
  end
end
