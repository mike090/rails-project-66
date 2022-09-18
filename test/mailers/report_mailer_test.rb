# frozen_string_literal: true

require 'test_helper'

class ReportMailerTest < ActionMailer::TestCase
  test 'repository_check_report' do
    check = repository_checks(:one)
    mail = ReportMailer.repository_check_report(check)
    assert { mail.subject == "repository #{check.repository.full_name} check report" }
    assert { mail.to == [check.repository.user.email] }
    assert { mail.from == ['from@example.com'] }
  end
end
