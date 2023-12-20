# frozen_string_literal: true

class AddPolymorphicContractModelToStatementOfWorks < ActiveRecord::Migration[7.0]
  def change
    add_column :statement_of_works, :contract_model_id, :integer
    add_column :statement_of_works, :contract_model_type, :string
    add_index :statement_of_works, %i[contract_model_id contract_model_type], name: 'index_sow_on_contract_model'
  end
end
