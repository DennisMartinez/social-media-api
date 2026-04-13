# frozen_string_literal: true

class AddOwnerToGroup < ActiveRecord::Migration[8.0]
  def change
    add_reference :groups, :owner, foreign_key: { to_table: :users }, null: true
  end
end
