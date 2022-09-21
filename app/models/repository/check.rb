# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository, class_name: :Repository

  aasm do
    state :checking, initial: true
    state :finished
    state :failed

    event :complete do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: :checking, to: :failed
    end
  end
end
