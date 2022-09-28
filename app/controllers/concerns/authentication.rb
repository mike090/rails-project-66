# frozen_string_literal: true

module Authentication
  class AuthenticationRequiredError < StandardError; end

  extend ActiveSupport::Concern

  included do
    rescue_from AuthenticationRequiredError, with: :authentication_required

    def current_user
      @current_user ||= User.find_by id: session[:user_id]
      @current_user ||= GuestUser.new
    end

    def signed_in?
      !current_user.is_a? GuestUser
    end

    def require_authentication
      return if signed_in?

      raise AuthenticationRequiredError
    end

    def authentication_required
      direction = request.referer || root_path
      redirect_to direction, warning: t('global.flash.not_signed_in')
    end

    helper_method :current_user, :signed_in?
  end
end
