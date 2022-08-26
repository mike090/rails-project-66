# frozen_string_literal: true

class AddGithubIdUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :repositories, %i[user_id github_id], unique: true
  end
end
