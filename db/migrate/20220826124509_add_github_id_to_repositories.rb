# frozen_string_literal: true

class AddGithubIdToRepositories < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :github_id, :integer, null: false, default: 0
  end
end
