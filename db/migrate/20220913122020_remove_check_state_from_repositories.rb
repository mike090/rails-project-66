class RemoveCheckStateFromRepositories < ActiveRecord::Migration[6.1]
  def change
    remove_column :repositories, :check_state
  end
end
