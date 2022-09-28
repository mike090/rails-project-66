# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'index' do
    get root_path
    assert_response :success
  end

  test 'index redirect' do
    sign_in users(:one)
    get root_path
    assert_redirected_to repositories_path
  end
end
