# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :nickname, null: false, index: { unique: true }
      t.string :token, null: false
      t.string :name
      t.string :image_url

      t.timestamps
    end
  end
end
