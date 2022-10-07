# frozen_string_literal: true

class GithubAdapterTest < ActionDispatch::IntegrationTest
  test 'set repo hook' do
    repo = repositories :one
    payload_url = Rails.application.routes.url_helpers.api_checks_url host: 'www.example.com'
    stub_request(:get, "https://api.github.com/repositories/#{repo.github_id}/hooks").to_return(
      status: 200,
      body: [].to_json,
      headers: { 'content-type' => 'application/json; charset=utf-8' }
    )
    stub_request(:post, "https://api.github.com/repositories/#{repo.github_id}/hooks").to_return(status: 201)
    GithubAdapter.set_repo_hook repo.id, payload_url
    assert_requested :post, "https://api.github.com/repositories/#{repo.github_id}/hooks", times: 1
  end
end
