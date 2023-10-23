# frozen_string_literal: true

class CreateSalaries < ActiveRecord::Migration[7.0]
  def change
    create_table :salaries do |t|
      t.float :yearly_salary
      t.datetime :start_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
