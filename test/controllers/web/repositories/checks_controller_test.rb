# frozen_string_literal: true

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should show' do
    sign_in users(:one)
    check = repository_checks(:one)
    get repository_check_path(id: check.id, repository_id: check.repository_id)
    assert_response :success
  end

  test 'test create' do
    sign_in users(:one)
    repo = repositories(:without_checks)
    post repository_checks_path(repo)
    check = repo.checks.first
    assert { check.finished? }
    assert_redirected_to repository_path(repo)
  end
end
