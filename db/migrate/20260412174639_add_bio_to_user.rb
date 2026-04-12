class AddBioToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text, limit: 1000
  end
end
