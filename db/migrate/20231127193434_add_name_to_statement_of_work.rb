# frozen_string_literal: true

class AddNameToStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    add_column :statement_of_works, :name, :string
  end
end
