# frozen_string_literal: true

require 'test_helper'

class ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'create new check' do
    repository = repositories(:one)
    assert_difference 'repository.checks.count' do
      post api_checks_path, params: { repository: { id: repository.github_id } }, headers: { 'X-GitHub-Event' => 'push' }
    end
    assert_response :success
  end
end
