class AddStateToRepositories < ActiveRecord::Migration[6.1]
  def change
    add_column :repositories, :state, :string, null: false, default: ''
  end
end
