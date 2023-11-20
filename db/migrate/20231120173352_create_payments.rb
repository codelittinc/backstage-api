# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.datetime :date
      t.float :amount
      t.references :statement_of_work, null: false, foreign_key: true

      t.timestamps
    end
  end
end
