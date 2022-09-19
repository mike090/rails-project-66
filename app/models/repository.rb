# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize
  include AASM

  belongs_to :user
  has_many :checks, dependent: :destroy, class_name: :Check

  validates :github_id, presence: true

  aasm column: :state do
    state :created, initial: true
    state :fetching
    state :actual
    state :failed

    event :start_fetching do
      transitions from: %i[created actual failed], to: :fetching
    end

    event :end_fetching do
      transitions from: :fetching, to: :actual
    end

    event :fail_fetching do
      transitions from: :fetching, to: :failed
    end
  end

  enumerize :language, in: (CodeChecker.languages | %i[Ruby JavaScript])
end
