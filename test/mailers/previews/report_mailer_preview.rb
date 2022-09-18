# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class ReportMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/report_mailer/repository_check_report
  def repository_check_report
    ReportMailer.repository_check_report Repository::Check.last
  end
end
