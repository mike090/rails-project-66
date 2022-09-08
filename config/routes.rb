# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    resources :repositories, only: %i[index new create show update], shallow: true do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/sing_out', as: :sing_out
  end
end
