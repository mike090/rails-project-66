class RemoveUserTokenNullConstraint < ActiveRecord::Migration[6.1]
  def change
    change_column_null :users, :token, true
  end
end
