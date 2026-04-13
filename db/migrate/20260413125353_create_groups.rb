class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false, limit: 255, index: { unique: true }
      t.text :bio, null: true, limit: 1000

      t.timestamps
    end
  end
end
