# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true

class TestHelper
  def self.why
    'for add test/ path to autoload_paths (to help you find AuthConcern) and avoid zeitwerk errors'
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.

  setup do
    queue_adapter.perform_enqueued_jobs = true
    queue_adapter.perform_enqueued_at_jobs = true
  end

  fixtures :all

  # Add more helper methods to be used by all tests here...

  def load_fixture(filename)
    File.read(File.dirname(__FILE__) + "/fixtures/#{filename}")
  end

  def sign_in(user, _options = {})
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: user.name,
        nickname: user.nickname,
        image: user.image_url
      },
      credentials: {
        token: 'token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # def mock_user_repos_list(repos_info)
  #   user_repos_list_uri = 'https://api.github.com/user/repos'
  #   stub_request(:get, user_repos_list_uri)
  #     .to_return status: 304, body: repos_info.to_json,
  #                headers: { 'content-type' => 'application/json; charset=utf-8' }
  # end

  # def mock_repo_info(repos_info)
  #   repos_info_uri_template = Addressable::Template.new 'https://api.github.com/repositories/{repo_id}'
  #   stub_request(:get, repos_info_uri_template)
  #     .to_return status: 304, body: repos_info.to_json,
  #                headers: { 'content-type' => 'application/json; charset=utf-8' }
  # end
end
