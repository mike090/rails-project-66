class RenameRepositoryCheckState < ActiveRecord::Migration[6.1]
  def change
    Repository::Check.where(aasm_state: 'performing').update_all(aasm_state: 'checking')
    Repository::Check.where(aasm_state: 'success').update_all(aasm_state: 'finished')
  end
end
