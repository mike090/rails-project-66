# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository, class_name: :Repository

  aasm do
    state :created, initial: true
    state :checking
    state :finished
    state :failed

    event :start_checking do
      transitions from: :created, to: :checking
    end

    event :complete do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: :checking, to: :failed
    end
  end
end
