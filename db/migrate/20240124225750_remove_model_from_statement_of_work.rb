# frozen_string_literal: true

class RemoveModelFromStatementOfWork < ActiveRecord::Migration[7.0]
  def change
    remove_column :statement_of_works, :model, :string
  end
end
