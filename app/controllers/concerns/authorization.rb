# frozen_string_literal: true

# frozen_sring_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorezed

    def authorize(record, query = nil, policy_class: nil)
      super record, query, policy_class: (policy_class || find_policy_class(record))
    end

    def policy(record)
      find_policy_class(record).new pundit_user, record
    end

    def policy_namespace
      nil
    end

    delegate :admin?, to: :current_user

    private

    def find_policy_class(record)
      record_class = record.is_a?(Class) ? record : record.class
      policy_name = if record_class == NilClass
                      'ApplicationPolicy'
                    else
                      "#{record_class.name}Policy"
                    end
      (policy_namespace || Object).const_get policy_name
    end

    def user_not_authorezed
      direction = request.referer || root_path
      redirect_to direction, warning: t('global.flash.not_authorized')
    end

    helper_method :admin?
  end
end
