# frozen_string_literal: true

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should show' do
    check = repository_checks(:one)
    get check_path(check)
    assert_response :success
  end

  test 'should create' do
    post repository_checks_path(repositories(:one))
    assert_redirected_to repository_path(repositories(:one))
  end
end