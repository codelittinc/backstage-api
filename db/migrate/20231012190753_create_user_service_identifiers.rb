# frozen_string_literal: true

class CreateUserServiceIdentifiers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_service_identifiers do |t|
      t.string :service_name
      t.references :customer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :identifier

      t.timestamps
    end
  end
end
