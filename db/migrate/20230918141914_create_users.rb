# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :google_id

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :google_id, unique: true
  end
end
