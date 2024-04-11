# frozen_string_literal: true

class AddOrderToDynamicDataset < ActiveRecord::Migration[7.0]
  def change
    add_column :dynamic_datasets, :order, :integer
  end
end
