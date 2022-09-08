class RemoveRepositoriesUniqueConstraints < ActiveRecord::Migration[6.1]
  def change
    change_column_null :repositories, :name, true
    change_column_null :repositories, :full_name, true
    change_column_null :repositories, :language, true
    change_column_null :repositories, :check_state, true
  end
end
