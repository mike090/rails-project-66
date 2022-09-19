class ChangeReposytoryChecksStructure < ActiveRecord::Migration[6.1]
  def change
    rename_column :repository_checks, :state, :aasm_state
    add_column :repository_checks, :passed, :boolean
  end
end
