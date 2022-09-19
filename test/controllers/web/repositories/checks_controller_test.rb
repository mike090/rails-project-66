# frozen_string_literal: true

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should show' do
    sign_in users(:one)
    check = repository_checks(:one)
    get repository_check_path(id: check.id, repository_id: check.repository_id)
    assert_response :success
  end

  test 'should create' do
    sign_in users(:one)
    post repository_checks_path(repositories(:one))
    assert_redirected_to repository_path(repositories(:one))
  end
end
