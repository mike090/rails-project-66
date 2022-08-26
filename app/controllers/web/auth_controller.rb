# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      user = User.find_or_initialize_by auth_params.slice :email

      unless user.attributes.slice(
        :email,
        :name,
        :nickname,
        :image_url,
        :token
      ) == auth_params.to_h
        user.attributes = auth_params.to_h
        user.save!
      end
      sign_in user
      redirect_to repositories_path, success: t('.welcome')
    end

    def sing_out
      session.delete :user_id
      @current_user = nil
      redirect_to root_path, success: t('.goodbye')
    end

    private

    def sign_in(user)
      session[:user_id] = user.id
      @current_user = user
    end

    def auth_params
      @auth_params ||= begin
        params = request.env['omniauth.auth'].info.merge request.env['omniauth.auth'].credentials
        params[:image_url] = params.delete :image
        ActionController::Parameters.new(params).permit(
          :email,
          :name,
          :nickname,
          :image_url,
          :token
        )
      end
    end
  end
end
