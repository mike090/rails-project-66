# frozen_string_literal: true

class CheckRepoJob < ApplicationJob
  queue_as :default

  class InvalidCheckState < StandardError; end

  def perform(check_id)
    check = Repository::Check.find check_id
    raise InvalidCheckState, "Invalid state: #{check.aasm_state}" unless check.checking?

    check.transaction do
      github_id = check.repository.github_id
      update_values = ApplicationContainer['repo_check_service'].call github_id, clone_url: check.repository.clone_url
      check.attributes = update_values if update_values
      check.complete
      check.save!
    end
    Rails.logger.info "Repository check id: #{check_id} successfly finished"
    ReportMailer.repository_check_report(check).deliver_now unless check.passed
  rescue StandardError => e
    Rails.logger.error "Repository check id: #{check_id} failed! Error: #{e.class} - #{e.message}"
    if check
      check.reload
      if check.may_fail?
        check.fail
        check.result = "#{e.class}: #{e.message}"
        check.save
        ReportMailer.repository_check_report(check).deliver_now
      end
    end
  end
end
