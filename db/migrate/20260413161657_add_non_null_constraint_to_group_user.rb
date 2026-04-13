class AddNonNullConstraintToGroupUser < ActiveRecord::Migration[8.0]
  def change
    change_column_null :groups, :owner_id, false
  end
end
