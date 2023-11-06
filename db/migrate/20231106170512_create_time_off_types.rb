# frozen_string_literal: true

class CreateTimeOffTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :time_off_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
