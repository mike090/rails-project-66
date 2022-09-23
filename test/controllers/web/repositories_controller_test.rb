# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test 'test index' do
    sign_in users(:one)
    get repositories_url
    assert_response :success
  end

  test 'test new' do
    sign_in users(:one)
    get new_repository_url
    assert_response :success
  end

  test 'test create' do
    sign_in users(:one)
    post repositories_url params: {
      repository: {
        github_id: 524_866_526
      }
    }
    repo = Repository.find_by(github_id: 524_866_526)
    assert { repo != nil? }
    assert { repo.language.present? }
    assert_redirected_to repositories_path
  end

  test 'test author show' do
    sign_in users(:one)
    get repository_url repositories(:one)
    assert_response :success
  end

  test 'test denied show' do
    sign_in users(:one)
    assert_raise(ActiveRecord::RecordNotFound) { get repository_url repositories(:two) }
  end
end
