# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.string :full_name, null: false, index: { unique: true }
      t.string :language, null: false
      t.boolean :check_state, null: false, default: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
