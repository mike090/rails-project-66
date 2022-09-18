# frozen_string_literal: true

class ReportMailer < ApplicationMailer
  helper(ApplicationHelper)

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.repository_check_report.subject
  #
  def repository_check_report(check)
    @check = check
    mail to: check.repository.user.email,
         subject: "repository #{check.repository.full_name} check report"
  end
end
