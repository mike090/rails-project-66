# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'should get repos list' do
    sign_in users(:one)
    get repositories_url
    assert_response :success
  end

  test 'should get new' do
    sign_in users(:one)
    mock_user_repos_list JSON.parse(load_fixture('files/user_repos.json'))
    get new_repository_url
    assert_response :success
  end

  test 'should create repository' do
    sign_in users(:one)
    post repositories_url params: {
      repository: {
        github_id: 123
      }
    }
    assert Repository.find_by(github_id: 123)
    assert_redirected_to repositories_path
  end

  test 'author can see its repo' do
    sign_in users(:one)
    get repository_url repositories(:one)
    assert_response :success
  end

  test 'user cannt see anothers repo' do
    sign_in users(:one)
    assert_raise(ActiveRecord::RecordNotFound) { get repository_url repositories(:two) }
  end
end
