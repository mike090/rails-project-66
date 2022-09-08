class ChangeDefaultRepositoriesCheckState < ActiveRecord::Migration[6.1]
  def change
    change_column_default :repositories, :check_state, nil
  end
end
