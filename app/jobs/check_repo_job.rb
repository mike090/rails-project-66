# frozen_string_literal: true

class CheckRepoJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    ApplicationContainer['repository_check_service'].call(check_id)
    check = Repository::Check.find check_id
    Rails.logger.info "Repository check id: #{check_id} successfly finished"
    ReportMailer.repository_check_report(check).deliver_later unless check.passed
  rescue StandardError => e
    Rails.logger.error "Repository check id: #{check_id} failed! Error: #{e.class} - #{e.message}"
    ReportMailer.repository_check_report(check).deliver_later if check
  end
end
