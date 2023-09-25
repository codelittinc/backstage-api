# frozen_string_literal: true

class AddProfessionRefToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :profession, foreign_key: true
  end
end
