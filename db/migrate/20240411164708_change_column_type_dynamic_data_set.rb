# frozen_string_literal: true

class ChangeColumnTypeDynamicDataSet < ActiveRecord::Migration[7.0]
  def change
    change_column :dynamic_datasets, :code, :text
  end
end
