class UpdateRepositoriesSate < ActiveRecord::Migration[6.1]
  def change
    Repository.update_all state: :actual
  end
end
