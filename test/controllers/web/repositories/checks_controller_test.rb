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
    repo = repositories(:one)
    assert_difference 'repo.checks.count' do
      post repository_checks_path(repo)
    end
    check = repo.checks.last
    assert check.finished?
    assert_redirected_to repository_path(repositories(:one))
  end
end
