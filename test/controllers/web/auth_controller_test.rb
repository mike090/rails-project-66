# frozen_string_literal: true

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'test new user login' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.name,
        nickname: Faker::Internet.username,
        image: 'image_url'
      },
      credentials: {
        token: 'token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')
    assert_response :redirect

    user = User.find_by!(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end

  test 'test user login' do
    user = users(:one)
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: user.email,
        name: 'User Name',
        nickname: user.nickname,
        image: 'image_url'
      },
      credentials: {
        token: 'token'
      }
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
    get callback_auth_url('github')
    assert_response :redirect
    assert signed_in?
    assert { current_user == user }
  end
end
