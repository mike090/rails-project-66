# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'select options' do
    @current_user = users(:one)
    mock_user_repos_list JSON.parse(load_fixture('files/user_repos.json'))
    assert { repository_select_options == [['one/java_script_repo', 333_333]] }
  end
end
