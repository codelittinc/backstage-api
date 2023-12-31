# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :target
      t.string :ability

      t.timestamps
    end
  end
end
