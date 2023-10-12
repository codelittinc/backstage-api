# frozen_string_literal: true

class AddOriginCountryToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :country, :string
  end
end
