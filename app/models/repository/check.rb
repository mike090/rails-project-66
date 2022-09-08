# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository, class_name: :Repository

  aasm column: :state do
    state :performing, initial: true
    state :success
    state :failed

    event :complete do
      transitions from: :performing, to: :success
    end

    event :fail do
      transitions from: :performing, to: :failed
    end
  end
end
