# frozen_string_literal: true

class AddInternalToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :internal, :boolean, default: true, null: false
  end
end
