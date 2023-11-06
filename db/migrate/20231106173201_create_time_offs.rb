# frozen_string_literal: true

class CreateTimeOffs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_offs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :time_off_type, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
