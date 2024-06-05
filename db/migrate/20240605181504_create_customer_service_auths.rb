# frozen_string_literal: true

class CreateCustomerServiceAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_service_auths do |t|
      t.string :auth_key
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
