# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :name, :full_name, :language, presence: true
  validates :check_state, inclusion: { in: [true, false] }
  validates :github_id, presence: true, uniqueness: { scope: :user_id }

  enumerize :language, in: %i[Ruby JavaScript]
end
