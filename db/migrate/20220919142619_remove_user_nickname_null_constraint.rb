class RemoveUserNicknameNullConstraint < ActiveRecord::Migration[6.1]
  def change
    remove_index :users, name: 'index_users_on_nickname'
    change_column_null :users, :nickname, true
  end
end
