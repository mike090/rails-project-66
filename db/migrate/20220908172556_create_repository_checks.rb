class CreateRepositoryChecks < ActiveRecord::Migration[6.1]
  def change
    create_table :repository_checks do |t|
      t.string :commit
      t.belongs_to :repository, null: false, foreign_key: true
      t.string :state, null: false
      t.json :result

      t.timestamps
    end
  end
end
